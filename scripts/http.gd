
extends Control

var headers=[
	"User-Agent: Pirulo/1.0 (Godot)",
	"Accept: */*"
]

#TODO http request liefert die response, sollten die errors abgefangen werden?
#TODO Was machen mit players wie werden sie geupdated siehe board get players problem
var err=0
var http = HTTPClient.new() # Create the Client
#var serverAdress
#var port 

func _init():
	pass
	
func _ready():
	#serverAdress = get_node("/root/global").get_ha_proxy()
	#port = get_node("/root/global").get_ha_proxy_port()
	pass

func get(adress):

	var uri_dict = get_link_address_port_path(adress)
	checkServerConnection(uri_dict["address"], uri_dict["port"])
	http.request(HTTPClient.METHOD_GET, uri_dict["path"], headers)
	
	return getResponse()
	
func put(adress):
	
	var uri_dict = get_link_address_port_path(adress)
	
	checkServerConnection(uri_dict["address"], uri_dict["port"])
	http.request(HTTPClient.METHOD_PUT, uri_dict["path"], headers)
	
	return getResponse()
	
func delete(adress):
	var uri_dict = get_link_address_port_path(adress)
	
	checkServerConnection(uri_dict["address"], uri_dict["port"])
	http.request(HTTPClient.METHOD_DELETE, uri_dict["path"], headers)
	
	return getResponse()
	
func post(adress, body):
	var uri_dict = get_link_address_port_path(adress)
	
	checkServerConnection(uri_dict["address"], uri_dict["port"])
	http.request(HTTPClient.METHOD_POST, uri_dict["path"], headers, body)
	
	return getResponse()
	
func get_link_address_port_path(uri):
	var address = uri.replace("http://", "")
	var host = address.split("/", true)[0]
	var adress_port = host.split(":", true)
	var path = uri.replace(adress_port[0]+":"+adress_port[1],"")
	return {
			"uri":uri, 
			"address":adress_port[0],
			"port":int(adress_port[1]),
			"path":path
			}
	
#func subscribe_to_event(event_Type,event_Name):
	
#	var playerUri ="http://" + IP.get_local_addresses()[1] + ":" + str(get_node("/root/response_server").get_port()) + "/player/event"
#	var gameid = get_node("/root/global").getCurrentGameId()
#	var player = get_player("localhost",4567,get_node("/root/global").getPlayerName().to_lower())
#	var player = get_node("/root/global").getPlayerName().to_lower()
#	var reason = ".*"
#	var name = event_Name
#	var subscription = {}
#	var event = {}
	
#	event["type"] = event_Type
#	event["name"] = event_Name
#	event["reason"] = reason
	#event["player"] = player
	
#	subscription["gameid"] = gameid
#	subscription["uri"] = playerUri 
#	subscription["event"] = event
	#print(subscription.to_json())
	#events/subscriptions
	#print(sendBodyTo(subscription.to_json(),"/subscriptions"))
	
#func get_player(playerID):
#	
#	checkServerConnection(serverAdress, port)
#	var gameId = get_node("/root/global").getCurrentGameId()
	
#	http.request(HTTPClient.METHOD_GET,"/games/" + gameId +"/players/" + playerID,headers)
	
	
#	var response = getResponse()
#	var dictionary = {}
	
#	dictionary.parse_json(response)
#	return response
	

func subcribe(channel, playerID):
	#join lobby chat
	var a = channel
	var b = { "id": playerID,
			  "subscribt_channels": [],
	          "uri": ""
	         }.to_json()
	post(a, b)

func checkServerConnection(serverAdress,port):
	var err = http.connect(serverAdress,port) # Connect to host/port

	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
		http.poll()
	

func getResponse():
	var bodyDict = {} 
	var rs = {}
	# Keep polling until the request is going on
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		http.poll()
	
	# If there is a response..
	if (http.has_response()):
		# Get response headers
		var headers = http.get_response_headers_as_dictionary()
        #This method works for both anyway
		var rb = RawArray() #array that will hold the data
		while(http.get_status()==HTTPClient.STATUS_BODY):
			# While there is body left to be read
			http.poll()
			# Get a chunk
			var chunk = http.read_response_body_chunk()
			rb = rb + chunk # append to read bufer
		var body = rb.get_string_from_ascii()
		
		rs["header"] = headers
		var err = bodyDict.parse_json(body)
		
		if(err):
			rs["body"] = body
		else:
			rs["body"] = bodyDict
			
		return rs