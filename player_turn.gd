
extends Node2D

#func _ready():
#	get_node("/root/response_server").add_service("player", self)

#func handle_request(verb, url, params, body_map, client):
#	print("SOME STUFF: " + verb)
#	if "POST" == verb:
#		if "/player/turn" == url:
#			print("TURN RECIEVED")
#			get_node("/root/global").setMyTurn(true)
#			if get_node("/root").has_node("Game") == true :
#				get_node("/root/Game/Overlay").set_turn_pressable()
	#pass
	#	if "/player/event" == url:
	#		handle_event(body_map)

#func handle_event(event):
#	print("Event handler : " + event.to_json())
#	if event["type"] == "roll":
#		pass
#	elif event["type"] == "platzhlater" : 
#		pass
#	elif event["type"] == "player_removed" : 
#		pass
#	pass