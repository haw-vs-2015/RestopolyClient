
extends Node

var global = null
var http = null

func _ready():
	
	global = get_node("/root/global")
	http = get_node("/root/http")
	
	
func rollDice():

	#TODO http request liefert die response, sollten die errors abgefangen werden?
	var dices = [0,0]
	var response1 = http.get("/dice")
	
	var rolls = {}
	rolls["roll1"] = response1
	dices[0] = response1["number"]

	var response2 = http.get("/dice")
	
	dices[1] = response1["number"]
	rolls["roll2"] = response2

	return rolls 

func send_end_turn_ready():
	http.put("/games/"+global.currentGameId+"/players/"+global.playerid+"/ready")
	
	
func send_roll_to_server(rolls):

	var playerId = global.playerid
	var gameId = global.getCurrentGameId()
	var adress = "/boards/" + gameId  +  "/players/" + playerId +  "/roll"
	var new_board = http.post(adress, rolls.to_json())

	#print(new_board.to_json())
	return new_board
