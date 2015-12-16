
extends WindowDialog

var selected_item = -1
var global = null
var controller = null

func _ready():
	
	global = get_node("/root/global")
	
	controller = get_node("/root/server_browser_controller")
	controller.server_browser = self
	
	randomize()
	get_node("PlayerNameInput").set_text( str( randi()%1000 ))
	
	global.setPlayerName(get_node("PlayerNameInput").get_text())
	
	#get_node("Refresh").connect("pressed",self,"refresh")
	get_node("Join").connect("pressed",self,"join_game")
	get_node("CreateButton").connect("pressed",self,"_create_game")
	get_close_button().remove_and_skip()
	
	
func join_game():
	
	
	if(selected_item != -1):
		global.setCurrentGameId(get_node("ItemList").get_item_text(selected_item))
		controller._join_game()
		controller.server_browser = null
		global.goto_scene("res://lobby.scn")

func refresh():
	
	var games = global.games
	get_node("ItemList").clear()
	
	for game in games:
		get_node("ItemList").add_item(game["gameid"])
		get_node("ItemList").set_item_metadata(get_node("ItemList").get_item_count() -1,game["gameid"])

func _create_game():
	controller._create_game()
	controller.server_browser = null
	global.goto_scene("res://lobby.scn")
	
func _on_ItemList_item_selected( index ):
	selected_item = index

func _on_PlayerName_text_changed( text ):
	global.setPlayerName(text)


func _on_PollTimer_timeout():
	refresh()
