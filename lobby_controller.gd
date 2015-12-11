
extends Node

var global = null
var http = null

func _ready():
	
	global = get_node("/root/global")
	http = get_node("/root/http")

 
func getGame():

	var gameId = global.getCurrentGameId()
	var response = http.get("/games/" + str(gameId))
	return response
	
	
func startGame():
	
	var gameId = global.getCurrentGameId()
	
	var response = http.put("/games/" + gameId + "/start" )
	return response
	
	
func setPlayerReady():
	
	print(IP.get_local_addresses())
	print(IP.resolve_hostname("192.168.178.20"))
	
	var gameId = global.getCurrentGameId()
	var playerId = global.getPlayerName().to_lower()
	
	var response = http.put("/games/" + gameId +  "/players/" + playerId + "/ready")
	return response


func leaveGame():


	var gameId = global.getCurrentGameId()
	var playerId = global.getPlayerName().to_lower() #Vileicht eher die id speichern und nicht kleiner machen

	var response = http.delete("/games/" + gameId + "/players/" + playerId)
	return response