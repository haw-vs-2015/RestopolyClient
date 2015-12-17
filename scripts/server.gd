
extends Node

var ip = ""
var port = 3560

var services = {}
var max_header_size = 8175
var server # for holding your TCP_Server object
var connection = null
var peerstream = null
var connected = false
var counter = 0

func _ready():
	ip = get_node("/root/global").ha_proxy
	connection = StreamPeerTCP.new()
	connection.connect( ip, port )
	peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer( connection )
	set_process(true)

func _process(delta):
	if !connected: # it's inside _process, so if last status was STATUS_CONNECTING
		if connection.get_status() == connection.STATUS_CONNECTED:
			print( "Connected to "+ip+" :"+str(port) )
			connected = true # finally you can use this var ;)
			#hello(get_node("/root/global").getPlayerName())
		elif connection.get_status() == StreamPeerTCP.STATUS_CONNECTING:
			print( "Trying to connect "+ip+" :"+str(port) )
		elif connection.get_status() == connection.STATUS_NONE or connection.get_status() == StreamPeerTCP.STATUS_ERROR:
			print( "Couldn't connect to "+ip+" :"+str(port) )
			print( "Server disconnected? " )
			set_process( false )
	else:
		
		if peerstream.get_available_packet_count() > 0:
			var header = ""
			var output = {}
			var header_size = 0
			
			#read header
			header = peerstream.get_var()
			#print("IN HEADER: " + header)
			#while(header.substr(header.length()-4, header.length()) != "\r\n\r\n"):
			#	header += connection.get_data(1)[1].get_string_from_utf8()
				#print(header)
			#	header_size += 1
				#if(header_size > max_header_size):
				#	header_error = true
			#print(header)
			#print("ICOMING" + header)
			#check maxHeader size error
			#if(!header_error):
				#print("Freeze?4")
				
			#output["header"] = _parse_header(header)
			#output["body"] = _parse_body(output["header"], connection)
			
			output["header"] = _parse_header(header.split("\r\n\r\n")[0])
			
			var body_string = header.split("\r\n\r\n")[1]
			if(body_string != null):
				var body = {}
				body.parse_json(body_string)
				output["body"] = body
			else:
				output["body"] = ""
			handle_request(output, connection)
			#	print("Freeze?3")
				#connection.disconnect()
			#else:
				#header too big error
			#	pass

func _parse_body(header, client):
	var body = {}
	if ("Content-Length" in header):
		var content_length = header["Content-Length"].to_int()
		if (content_length != 0 ):
			body.parse_json(client.get_data(content_length)[1].get_string_from_utf8())
	return body

func _parse_header(request):
	var requestLine = {}
	var requestHeaders
	var messagetBody
	
	#var no_eof = request.replace("\r\n\r\n", "")
	var lines = request.split("\r\n", true)
	#var lines = no_eof.split("\r\n", true)
	
	#parse first request line 
	requestLine["verb"] = lines[0].split(" ",false)[0]
	requestLine["url"] = lines[0].split(" ",false)[1]
	requestLine["version"] = lines[0].split(" ",false)[2]
	
	#TODO?: Ich glaub hier muss requestLine["url"] rein
	var s = Array(requestLine["url"].split("/",true))
	if(s.size()>1):
		requestLine["service"] = s[1]
	else:
		requestLine["service"] = ""
	
	#needs to check if service is a response and not a request
	
	#Wo ist die Zweiten informations line?
	#DONE: DELETE FIRST LINE ITS DATATRASH !!!!!!
	var lines_as_array = Array(lines)
	lines_as_array.remove(0)
	lines = StringArray(lines_as_array)
	
	#parse header
	for line in lines:
		if line != "":
			#DONE: Save an Array if the value is seperated by spaces 
			var pair = line.split(": ", false)
			var key = pair[0]
			var value = pair[1].split("; ", true)
			#Falls nur einer im StringArray, diesen als String ablegen
			#TODO: else Zweig, StringArray vielleicht als Array ablegen?
			#TODO Ist noch falsch das array...?
			if( value.size() <= 1 ):
				value = value[0]
			requestLine[key] = value
	return requestLine

func handle_request(request, client):
	
	#Alex optimierungstest
	var header = request["header"]
	var service = header["service"]
	var url = header["url"]
	var verb = header["verb"]
	#TODO: parsen der Parameter mit :param?
	#print("handle_request: " + url)
	if url in services:
		#print("handle_request found: " + url)
		services[url].handle_request(verb, url, "", request["body"], connection)
	#ok()
	# für alle anderen falschen ein 404 zurück 

func ok():
	peerstream.put_data(("HTTP/1.1 200 Ok\r\n"+ "Content-Type: application/json; charset=UTF-8\r\n" +"\r\n").to_utf8())
	pass
	
func not_found():
	connection.put_data(("HTTP/1.1 404 NotFound\r\n"+ "Content-Type: application/json; charset=UTF-8\r\n" +"\r\n").to_utf8())

#func getMyPlayerID(name):
#	var body = "{\"name\":\""+ name + "\"}"
#	connection.put_data(("GET /name HTTP/1.1\r\nContent-Length: " + str(body.length()) + "\r\n\r\n" + body).to_utf8())

func add_service(service, object):
	services[service] = object
	
func get_port():
	return port

#Was das?
func _on_Button_Back_pressed():
	if server:
		server.stop()
	get_node("../Menu").show()
	queue_free() # remove yourself at idle frame