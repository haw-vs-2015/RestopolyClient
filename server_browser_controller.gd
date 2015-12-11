
extends Node

var global = null
var http = null

func _ready():
	
	global = get_node("/root/global")
	http = get_node("/root/http")


func get_games():
	
	
	#print("GET GAMES TRIGGERED")
	#print("ServerAdress  = " + serverAdress)
	var response = http.get("/games")
	return response["games"]
	
func _join_game():
	
	#print("JOIN GAME TRIGGERED")
	var playerName = global.getPlayerName()
	var playerUri = global.playerUri
	
	var playerID = playerName.to_lower()
	var gameId = global.getCurrentGameId()

	var response = http.put("/games/" + str(gameId) +  "/players/" + playerID + "?name=" + playerName + "&uri=" + playerUri)
	
	#join lobby chat
	var a = "/messages/subscribe/lobby" + str(gameId)
	var b = { "name": playerName,
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
	
	var playerID = playerName.to_lower()
	var gameId = global.getCurrentGameId()
	
	#var request = "/games/" + str(gameId) +  "/players/" + playerID + "?name=" + playerName + "&uri=" + playerUri
	#print("DEBBUG" + request)

	var response = http.put("/games/" + str(gameId) +  "/players/" + playerID + "?name=" + playerName + "&uri=" + playerUri)
	
	#join lobby chat
	var a = "/messages/subscribe/lobby" + str(gameId)
	var b = { "name": playerName,
	          "uri": playerUri
	         }.to_json()
	
	http.post(a, b)
	
	return response
