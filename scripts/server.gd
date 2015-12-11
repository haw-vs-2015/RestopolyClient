
extends Node

var port = 3560

var services = {}
var max_header_size = 8175
var server # for holding your TCP_Server object
var connection = [] # for holding multiple connection (StreamPeerTCP) objects

func _ready():
	
	server = TCP_Server.new()
	
	#Set the port to listen to. If the port is already taken (server.listen returns != 0) a debugtext is output.
	if server.listen( port ) == 0:
		print("Server started on port " + str(port))
		set_process(true)
	else:
		print("Failed to start server on port" +str( port))

func _process(delta):
	if server.is_connection_available():
		
		# accept connection
		var client = server.take_connection()
		
		var header = ""
		var header_error = false
		var output = {}
		var header_size = 0
		
		#read header
		while(!header_error && !header.substr(header.length()-4, header.length()) == "\r\n\r\n"):
			header += client.get_data(1)[1].get_string_from_utf8()
			header_size += 1
			if(header_size > max_header_size):
				header_error = true
			
		#check maxHeader size error
		if(!header_error):
			output["header"] = _parse_header(header)
			output["body"] = _parse_body(output["header"], client)

			handle_request(output, client)
			client.disconnect()
		else:
			#header too big error
			pass
		header_size = 0

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
	
	var no_eof = request.replace("\r\n\r\n", "")
	var lines = no_eof.split("\r\n", true)
	
	#parse first request line 
	requestLine["verb"] = lines[0].split(" ",false)[0]
	requestLine["url"] = lines[0].split(" ",false)[1]
	requestLine["version"] = lines[0].split(" ",false)[2]
	requestLine["service"] = lines[0].split("/",false)[1]
	
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
	
	if service in services:
		services[service].handle_request(verb, url, "", request["body"], client)
	ok(client)
	# für alle anderen falschen ein 404 zurück 

func ok(client):
	client.put_data(("HTTP/1.1 200 Ok\r\n"+ "Content-Type: application/json; charset=UTF-8\r\n" +"\r\n").to_utf8())

func not_found(client):
	client.put_data(("HTTP/1.1 404 NotFound\r\n"+ "Content-Type: application/json; charset=UTF-8\r\n" +"\r\n").to_utf8())

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