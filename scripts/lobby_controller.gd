
extends Node

var global = null
var http = null
var lobby = null
var board = null # wenn board da ist, einfügen

func _ready():
	global = get_node("/root/global")
	http = get_node("/root/http")
	
func handle_request(verb, url, params, body_map, client):
	#need to make sure that lobby.scn is not null
	
	
	if "POST" == verb:
		var message_id = body_map["reason"]
		if "start_game" == message_id:
			print("START GAME erhalten")
			if lobby != null:
				lobby.start_game()
			
		elif "update_players" == message_id:
			
			var dic = {}
			dic.parse_json(body_map["payload"])
			#print(str(dic))
			global.players = dic["players"]
			if lobby != null:
				lobby.refresh()
			
		elif "chat_message" == message_id:
			print("Neue Nachricht erhalten")
			if lobby != null:
				lobby.get_node("Chat").get_node("ItemList").add_item(body_map["id"] + ": " + body_map["payload"])
		
		elif "player_turn" == message_id:
			print("TURN RECIEVED")
			get_node("/root/global").setMyTurn(true)
			if get_node("/root").has_node("Game") == true :
				get_node("/root/Game/Overlay").set_turn_pressable()
		elif "update_board" == message_id:
			#update field
			#update player turn
			print("BOARD AKTUALISIERT NACH ROLL")
		pass
	
func send_start_game():
	
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
	var playerID = global.playerid

	var response = http.delete("/games/" + str(gameId) + "/players/" + str(playerID))
	return response