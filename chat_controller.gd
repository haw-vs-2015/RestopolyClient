
extends Node

var chat_ui = null
var global = null
var http = null

func _ready():
	get_node("/root/response_server").add_service("messages", self)
	global = get_node("/root/global")
	http = get_node("/root/http")

func handle_request(verb, url, params, body_map, client):
	pass
