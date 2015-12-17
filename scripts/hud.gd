extends Node2D

#var cards[] = {}
var card = preload("res://card.scn")


func _ready():
	
	
	get_node("MultiplayerHUD/ServerBrowser").popup()

	var screen_size = get_viewport_rect().size
	set_pos(Vector2(screen_size.x/2,screen_size.y/2))
	get_node("DiceSprite").set_pos(Vector2(-get_node("DiceSprite").get_texture().get_width()/2,0))
	get_node("DiceSprite1").set_pos(Vector2(get_node("DiceSprite").get_texture().get_width()/2,0))
#	displayCards()
	pass
	
	
func roll(number,number1):
	get_node("SamplePlayer2D").play("rollDice")
	get_node("DiceSprite").set_texture(load("res://assets/sprites/dice/" + str(number) + ".png"))
	get_node("DiceSprite1").set_texture(load("res://assets/sprites/dice/" + str(number1) + ".png"))
	get_node("AnimationPlayer").play("showDice")
	

#func displayCards():
#	add_child(cards[1])
	
#func checkCards():
#	cards[1] = card.instance().setValues("Penis","1","2","3","4","5","6","7","8","9")
	
	
