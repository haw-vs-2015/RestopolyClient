
extends Control

var headers=[
	"User-Agent: Pirulo/1.0 (Godot)",
	"Accept: */*"
]
#TODO http request liefert die response, sollten die errors abgefangen werden?
#TODO Was machen mit players wie werden sie geupdated siege board get players problem
var err=0
var http = HTTPClient.new() # Create the Client
var serverAdress
var port 

func _init():
	pass
	
func _ready():
	serverAdress = get_node("/root/global").get_ha_proxy()
	port = get_node("/root/global").get_ha_proxy_port()
	#print("Adress = " + serverAdress)

func get(adress):
	checkServerConnection(serverAdress, port)
	
	http.request(HTTPClient.METHOD_GET, adress, headers)
	
	var output = {}
	output.parse_json(getResponse())
	#print("OUTPUT ------------> " + output.to_json())
	return output
	
func put(adress):
	checkServerConnection(serverAdress, port)
	
	http.request(HTTPClient.METHOD_PUT, adress, headers)
	
	var output = {}
	output.parse_json(getResponse())
	#print("OUTPUT ------------> " + output.to_json())
	return output
	
func delete(adress):
	checkServerConnection(serverAdress, port)
	
	http.request(HTTPClient.METHOD_DELETE, adress, headers)
	
	var output = {}
	output.parse_json(getResponse())
	#print("OUTPUT ------------> " + output.to_json())
	return output

func post(adress, body):
	#print("SEND BODY TRIGGERD")
	
	checkServerConnection(serverAdress,port)
	http.request(HTTPClient.METHOD_POST,adress,headers, body)
	
	var output = {}
	output.parse_json(getResponse())
	#print("OUTPUT ------------> " + output.to_json())
	return output
	
	
func subscribe_to_event(event_Type,event_Name):
	
	
	var playerUri ="http://" + IP.get_local_addresses()[1] + ":" + str(get_node("/root/response_server").get_port()) + "/player/event"
	var gameid = get_node("/root/global").getCurrentGameId()
	var player = get_player("localhost",4567,get_node("/root/global").getPlayerName().to_lower())
	var player = get_node("/root/global").getPlayerName().to_lower()
	var reason = ".*"
	var name = event_Name
	var subscription = {}
	var event = {}
	
	event["type"] = event_Type
	event["name"] = event_Name
	event["reason"] = reason
	#event["player"] = player
	
	subscription["gameid"] = gameid
	subscription["uri"] = playerUri 
	subscription["event"] = event
	#print(subscription.to_json())
	#events/subscriptions
	#print(sendBodyTo(subscription.to_json(),"/subscriptions"))
	
func get_player(playerID):

	
	checkServerConnection(serverAdress,port)
	var gameId = get_node("/root/global").getCurrentGameId()
	
	http.request(HTTPClient.METHOD_GET,"/games/" + gameId +"/players/" + playerID,headers)


	var response = getResponse()
	var dictionary = {}
	
	dictionary.parse_json(response)
	return response
	

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
		var text = rb.get_string_from_ascii()
		return text