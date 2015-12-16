
extends Node2D

var map = {}

func _ready():
	get_node("Button").connect("pressed",self,"_onSendPressed")
	get_node("LineEdit").connect("input_event",self,"_onSendPressed")
	get_node("/root/chat_controller").chat_ui = self


func _onSendPressed():
	var playerid = get_node("/root/global").playerid
	var gameid = get_node("/root/global").getCurrentGameId()
	var playeruri = get_node("/root/global").playerUri
	
	var a = "/messages/send/lobby" + str(gameid)

	var b = { "id":playerid,
			  "reason":"message",
			  "sourceURI":playeruri,
			  "payload":get_node("LineEdit").get_text()
			}.to_json()
			
	get_node("/root/http").post(a, b)
	get_node("LineEdit").set_text("")