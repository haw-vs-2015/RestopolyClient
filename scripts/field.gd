
extends Position3D

# member variables here, example:
# var a=2
# var b="textvar"
var players = []


func _ready():
	# Initialization here
	pass

func get_position():
	# später mit anzahl der player auf feld arbeiten, damit keine Überschneidung
	return get_translation() 

