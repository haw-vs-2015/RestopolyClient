
extends Node

var server_browser = null

func _ready():
	
	get_node("/root/response_server").add_service("/id", self)
	get_node("/root/response_server").add_service("/messages/send/update_games", self)
	
func handle_request(verb, url, params, body_map, client):
	
	if "POST" == verb:
		
		var message_id = body_map["reason"]
		if "set_playerid" == message_id:
			global.playerid = body_map["id"]
			http.subcribe(global.ip + "/messages/subscribe/update_games", global.playerid)
			
		elif "update_games" == message_id:
			print("Neue Nachricht erhalten")
			#WIESO nochmal parsen, wieso ist es ein string??
			var dic = {}
			dic.parse_json(body_map["payload"])
			global.games = dic["games"]
			if server_browser != null:
				server_browser.refresh()
	pass

func get_game():

	var response = http.get(global.game["uri"])
	return response
	
	
func get_games():
	#TODO Event einbauen, polling entfernen?
	#print("GETGAMES GAMES = " + str(global.games))
	var games = {}
	
	var response = http.get(global.ip + "/games")
	
	for game in response["body"]["games"]:
		games[game["name"]] = game
	global.games = games
	return response["body"]["games"]
	
	
func _join_game(gameid):
	
	global.gameUri = global.games[gameid]["uri"]
	global.game = http.get(global.gameUri)["body"]
	
	#print("JOIN GAME TRIGGERED")
	var playerName = global.getPlayerName()
	var playerUri = global.playerUri
	
	var playerID = global.playerid
	var gameId = global.getCurrentGameId()

	var response = http.put(global.game["players"] + str(playerID) + "?name=" + playerName + "&uri=" + playerUri)
	
	#TODO player name und id trennen! probleme bei spieler leaven und in mehreren spielen gleichzeitig sein
	
	global.players = get_game()["players"]
	
	#join lobby chat
	#http.subcribe("/messages/subscribe/" + str(gameId), playerID)
	
	return response
	
	
func _create_game():
	
	# create game
	global.gameUri = http.post(global.ip + "/games", "")["header"]["Location"]
	global.game = http.get(global.gameUri)["body"]
	
	# join game
	var playerName = global.getPlayerName()
	var playerUri = global.playerUri
	
	var playerID = global.playerid
	
	#var request = "/games/" + str(gameId) +  "/players/" + playerID + "?name=" + playerName + "&uri=" + playerUri
	#print("DEBBUG" + request)
	var response = http.put(global.game["players"] + str(playerID) + "?name=" + playerName + "&uri=" + playerUri)
	global.player = response["body"]
	
	#join lobby chat
	#http.subcribe("/messages/subscribe/" + str(gameId), playerID)
	
	return response
