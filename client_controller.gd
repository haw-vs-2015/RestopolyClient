
extends Node


func _ready():
	get_node("/root/response_server").add_service("messages", self)
	

func handle_request(verb, url, params, body_map, client):
	if "POST" == verb:
		if "/messages/send/lobby" + get_node("/root/global").currentGameId == url:
			get_node("ItemList").add_item(body_map["id"] + ": " + body_map["payload"])

