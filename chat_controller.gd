
extends Node

var chat_ui = null
var global = null
var http = null

func _ready():
	get_node("/root/response_server").add_service("messages", self)
	global = get_node("/root/global")
	http = get_node("/root/http")

func handle_request(verb, url, params, body_map, client):
	if "POST" == verb:
		if "/messages/send/lobby" + str(global.currentGameId) == url:
			chat_ui.get_node("ItemList").add_item(body_map["id"] + ": " + body_map["payload"])
		elif "/messages/send/updategames" == url:
			#WIESO nochmal ksn parsen, wieso ist es ein string??
			var dic = {}
			dic.parse_json(body_map["payload"])
			global.games = dic["games"]
