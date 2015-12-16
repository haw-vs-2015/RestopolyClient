
extends Node

var global = null
var http = null

func _ready():
	
	get_node("/root/response_server").add_service("games", self)
	global = get_node("/root/global")
	http = get_node("/root/http")
	
func handle_request(verb, url, params, body_map, client):
	if "POST" == verb:
		if "/games/start" == url:
			print("START GAME erhalten")
			startGame()
	pass
	
func startGame():
	
	var gameId = global.getCurrentGameId()
	
	var response = http.put("/games/" + gameId + "/start" )
	return response
	
	
func setPlayerReady():
	
	var gameId = global.getCurrentGameId()
	var playerId = global.playerid
	
	var response = http.put("/games/" + gameId +  "/players/" + playerId + "/ready")
	return response


func leaveGame():


	var gameId = global.getCurrentGameId()
	var playerId = global.playerid

	var response = http.delete("/games/" + gameId + "/players/" + playerId)
	return response