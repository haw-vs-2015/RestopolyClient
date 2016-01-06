
extends Node

var global = null
var http = null

func _ready():
	
	global = get_node("/root/global")
	http = get_node("/root/http")
	
	
func rollDice():

	#TODO http request liefert die response, sollten die errors abgefangen werden?
	var dices = [0,0]
	print(global.game["components"]["dice"])
	var response1 = http.get(global.game["components"]["dice"])["body"]
	
	var rolls = {}
	rolls["roll1"] = response1
	dices[0] = response1["number"]

	var response2 = http.get(global.game["components"]["dice"])["body"]
	
	dices[1] = response1["number"]
	rolls["roll2"] = response2

	return rolls 

func send_end_turn_ready():
	http.put(global.player["ready"])
	
	
func send_roll_to_server(rolls):

	var playerId = global.playerid
	print(global.game["components"]["board"])
	var adress = global.game["components"]["board"]  +  "/players/" + playerId +  "/roll"
	var new_board = http.post(adress, rolls.to_json())["body"]
	print(new_board)
	#print(new_board.to_json())
	return new_board
