
extends Node2D

var card = preload("res://card.scn")
var names = ["popel","pipi","kaka","asdas","asdasdas","asdasdasdas"]
# todo positioning 2 sind links aus bild 
func _ready():
	get_node("/root/global").setPlayerName("penis")
	get_node("/root/global").setCurrentGameId("1")
	get_node("/root/http").subscribe_to_event("roll","Würfel")
	var screen_size = get_viewport_rect().size
	# abstand = card with / 3 
	var counter = 0
	for name in names:
		print(counter)
		var card_instance = card.instance()
		card_instance.set_name(name)
		add_child(card_instance)
		var size = get_node(name).get_size()
		print(str(size))
		print(counter * 50)
		get_node(name).set_pos(Vector2((counter * (size.x / 6)),screen_size.y))
		counter = counter + 1 


