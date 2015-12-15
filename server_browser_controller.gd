
extends Node

var global = null
var http = null
var controller_lobby = null

func _ready():
	
	get_node("/root/response_server").add_service("id", self)
	global = get_node("/root/global")
	http = get_node("/root/http")
	
func handle_request(verb, url, params, body_map, client):
	if "POST" == verb:
		if "/id" == url:
			global.playerid = body_map["id"]
		elif "/id/updategames" == url:
			global.servers = body_map["games"]
	pass

func get_game():

	var gameId = global.getCurrentGameId()
	var response = http.get("/games/" + str(gameId))
	return response
	
func get_games():
	
	#print("GET GAMES TRIGGERED")
	#print("ServerAdress  = " + serverAdress)
	var response = http.get("/games")
	return response["games"]
	
func _join_game():
	
	#print("JOIN GAME TRIGGERED")
	var playerName = global.getPlayerName()
	var playerUri = global.playerUri
	
	var playerID = global.playerid
	var gameId = global.getCurrentGameId()

	var response = http.put("/games/" + str(gameId) +  "/players/" + playerID + "?name=" + playerName + "&uri=" + playerUri)
	
	#TODO player name und id trennen! probleme bei spieler leaven und in mehreren spielen gleichzeitig sein
	
	
	global.players = get_game()["players"]
	
	#join lobby chat
	var a = "/messages/subscribe/lobby" + str(gameId)
	var b = { "id": playerID,
	          "uri": playerUri
	         }.to_json()
	
	http.post(a, b)
	
	return response


func _create_game():
	
	
	# create game
	global.setCurrentGameId(http.post("/games", "")["gameid"])
	
	# join game
	var playerName = global.getPlayerName()
	var playerUri = global.playerUri
	
	var playerID = global.playerid
	var gameId = global.getCurrentGameId()
	
	#var request = "/games/" + str(gameId) +  "/players/" + playerID + "?name=" + playerName + "&uri=" + playerUri
	#print("DEBBUG" + request)

	var response = http.put("/games/" + str(gameId) +  "/players/" + playerID + "?name=" + playerName + "&uri=" + playerUri)
	
	#join lobby chat
	var a = "/messages/subscribe/lobby" + str(gameId)
	var b = { "id": playerID,
	          "uri": playerUri
	         }.to_json()
	
	http.post(a, b)
	
	return response
