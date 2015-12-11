
extends Node2D

var map = {}

func _ready():
	get_node("/root/response_server").add_service("messages", self)
	get_node("Button").connect("pressed",self,"_onSendPressed")
	get_node("LineEdit").connect("input_event",self,"_onSendPressed")


func handle_request(verb, url, params, body_map, client):
	if "POST" == verb:
		if "/messages/send/lobby" + get_node("/root/global").currentGameId == url:
			get_node("ItemList").add_item(body_map["name"] + ": " + body_map["payload"])
	pass


func _onSendPressed():
	var playerid = get_node("/root/global").getPlayerName()
	var gameid = get_node("/root/global").getCurrentGameId()
	var playeruri = get_node("/root/global").playerUri
	
	var a = "/messages/send/lobby" + str(gameid)

	var b = { "name":playerid,
			  "reason":"message",
			  "sourceURI":playeruri,
			  "payload":get_node("LineEdit").get_text()
			}.to_json()
			
	get_node("/root/http").post(a, b)
	get_node("LineEdit").set_text("")