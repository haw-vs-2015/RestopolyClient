
extends Node2D

var map = {}

func _ready():
	get_node("Button").connect("pressed",self,"_onSendPressed")
	get_node("LineEdit").connect("input_event",self,"_onSendPressed")
	get_node("RichTextLabel").set_selection_enabled(true)
	get_node("RichTextLabel").set_scroll_follow(true)

func _onSendPressed():
	var playerid = get_node("/root/global").playerid
	var gameid = get_node("/root/global").game["gameid"]
	var playeruri = get_node("/root/global").playerUri
	
	var a = get_node("/root/global").ip + "/messages/send/" + str(gameid)

	var b = { "id":playerid,
			  "reason":"chat_message",
			  "sourceURI":playeruri,
			  "payload":get_node("LineEdit").get_text()
			}.to_json()
	#print(b)
	get_node("/root/http").post(a, b)
	get_node("LineEdit").set_text("")
	
func add_message(message):
	get_node("RichTextLabel").add_text(message)
	get_node("RichTextLabel").newline()