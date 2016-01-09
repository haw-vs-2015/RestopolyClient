
extends Node

var global = null
var http = null
var lobby = null
var board = null # wenn board da ist, einfügen
var overlay = null 

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
			print("UPDATE PLAYER")
			var dic = {}
			dic.parse_json(body_map["payload"])
			#print(str(dic))
			global.players = dic["players"]
			if lobby != null:
				lobby.refresh()
			
			if overlay != null:
				print("OVERLAY IS NOT NULL\n")
				print("Global Player ID = " + global.players[0]["id"])
				if global.players[0]["id"] == global.playerid:
					overlay.set_turn_pressable()
				else:
					overlay.set_turn_unpressable()
				
		elif "chat_message" == message_id:
			print("Neue Nachricht erhalten")
			if lobby != null && overlay == null:
				lobby.get_node("Chat").add_message(body_map["id"] + ": " + body_map["payload"])
			if(overlay != null):
				overlay.get_node("Chat").add_message(body_map["id"] + ": " + body_map["payload"])
		elif "player_turn" == message_id:
			print("TURN RECIEVED")
			get_node("/root/global").setMyTurn(true)
			if get_node("/root").has_node("Game") == true :
				get_node("/root/Game/Overlay").set_turn_pressable()
		elif "update_board" == message_id:
			if board != null:
				print("UPDATE!!!!!!!!!!!!!!!!!!!!!!!!\n " + body_map.to_json())
				var dic = {}
				dic.parse_json(body_map["payload"])
				for field in dic["board"]["fields"]:
					if field["players"] != [] :
						for player in field["players"]:
							board.put_player_on_field(player["id"],player["position"])
		pass
	
func send_start_game():
	
	var response = http.put(global.gameUri + "/start" )
	return response
	
	
func setPlayerReady():
	
	var playerId = global.playerid
	
	var response = http.put(global.player["ready"])
	return response
	
	
func leaveGame():

	var gameId = global.getCurrentGameId()
	var playerID = global.playerid

	var response = http.delete("/games/" + str(gameId) + "/players/" + str(playerID))
	return response