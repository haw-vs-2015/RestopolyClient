
extends Spatial

var name 
var houses = 0
var hotel = false
var owner 
var price 
var rent = [] # [none,one,two,three,hotel]
var players = [] # players on field 

func _ready():
	# Initialization here
	pass

func buy(player):
	pass
	
func get_position():
	# später mit anzahl der player auf feld arbeiten, damit keine Überschneidung
	return get_translation()

func get_rent():
	if !hotel:
		return rent[houses]
	else :
		return rent[5]
		
func set_rents(none,one,two,three,four,hotel):
	rent[0] = none
	rent[1] = one
	rent[2] = two 
	rent[3] = three
	rent[4] = four
	rent[5] = hotel