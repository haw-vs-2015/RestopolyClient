extends Node2D

#var cards[] = {}
var card = preload("res://card.scn")
var controller = null
var global = null

func _ready():

	controller = get_node("/root/overlay_controller")
	global = get_node("/root/global")
	
	var screen_size = get_viewport_rect().size
	set_pos(Vector2(screen_size.x/2,screen_size.y/2))
	get_node("DiceSprite").set_pos(Vector2(-get_node("DiceSprite").get_texture().get_width()/2,0))
	get_node("DiceSprite1").set_pos(Vector2(get_node("DiceSprite").get_texture().get_width()/2,0))
	get_node("Roll Dice").connect("pressed",self,"_roll")
	get_node("Roll Dice").set_disabled(!get_node("/root/global").getMyTurn())
	get_node("End Turn").connect("pressed",self,"_end_turn")
	get_node("End Turn").set_disabled(!get_node("/root/global").getMyTurn())
#	displayCards()
	pass
	
	
func _roll():
	var dices = controller.rollDice()
	get_node("SamplePlayer2D").play("rollDice")
	var new_Field = controller.send_roll_to_server(dices)
	for field in new_Field["board"]["fields"]:
		if field["players"] != [] :
			for player in field["players"]:
				if player["id"] == global.playerid: 
					print("---------------------------------------------------" + str(player["position"]))
					get_parent().get_node("Board").put_player_on_field(get_node("/root/global").getPlayerName(),player["position"])
	get_node("DiceSprite").set_texture(load("res://assets/sprites/dice/" + str(dices["roll1"]["number"]) + ".png"))
	get_node("DiceSprite1").set_texture(load("res://assets/sprites/dice/" + str(dices["roll2"]["number"]) + ".png"))
	get_node("AnimationPlayer").play("showDice")

func _end_turn():
	get_node("End Turn").set_disabled(true)
	controller.send_end_turn_ready()


func set_turn_pressable():
	get_node("End Turn").set_disabled(false)
	get_node("Roll Dice").set_disabled(false)
#func displayCards():
#	add_child(cards[1])
	
#func checkCards():
#	cards[1] = card.instance().setValues("Penis","1","2","3","4","5","6","7","8","9")
	
	
