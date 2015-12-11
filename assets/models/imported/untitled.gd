xtends Spatial

var rotations = {1 : Vector3(deg2rad(0),deg2rad(0),deg2rad(90)),
				 2 : Vector3(deg2rad(0),deg2rad(0),deg2rad(0)),
				 3 : Vector3(deg2rad(0),deg2rad(270),deg2rad(0)),
				 4 : Vector3(deg2rad(0),deg2rad(90),deg2rad(90)),
				 5 : Vector3(deg2rad(0),deg2rad(0),deg2rad(90)),
				 6 : Vector3(deg2rad(0),deg2rad(180),deg2rad(90)),}

func _ready():
	showNumber(2)
	pass
	
func showNumber(number):
	if (! rotations.has(number)):
		print("A wrong Number has been requested.")
		return
		
	get_node("Dice").set_rotation(rotations[number])


