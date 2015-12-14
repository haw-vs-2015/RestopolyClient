
extends Panel

var controller = null
var global = null

func _ready():
	
	global = get_node("/root/global")
	controller = get_node("/root/lobby_controller")
	
	get_node("ReadyButton").connect("pressed",self,"_onReadyPressed")
	get_node("StartGame").connect("pressed",self,"_onStartPressed")
	get_node("LeaveButton").connect("pressed",self,"_leaveGame")
	get_node("StartGame").set_disabled(true)
	
	pass
	

func refresh():

	#print(controller.getGame())
	var players = global.players
	
	var allPlayersReady = true
	get_node("ItemList").clear()
	for player in players:
		if(player["ready"] == false):
			allPlayersReady = false
			
		get_node("ItemList").add_item(player["name"] + "  " + str(player["ready"]))
		
	if(allPlayersReady):
		get_node("StartGame").set_disabled(false)

func _onReadyPressed():
	controller.setPlayerReady()
	
	
func _onStartPressed():
	controller.startGame()
	get_node("/root/global").goto_scene("res://game.scn")
	
func _leaveGame():
	controller.leaveGame()
	get_node("/root/global").goto_scene("res://hud.scn") 

func _on_PollTimer_timeout():
	refresh()
	pass
	
	
