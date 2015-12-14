
extends Spatial

var figure = preload("res://assets/models/imported/godotfigure.scn")
var house = preload("res://assets/models/imported/house.scn")
var hotel = preload("res://assets/models/imported/hotel.scn") 
var player_movement_vector = Vector3(1,0,0)
var positions


func _ready():
	positions  = [get_node("Start"),
	get_node("James Brown Avenue"),
	get_node("Community Chest1"),
	get_node("Westwood Avenue"),
	get_node("Council Tax"),
	get_node("Ayr Station"),
	get_node("Prestwick Road"),
	get_node("Chance1"),
	get_node("Holmston Road"),
	get_node("Castlehill Road"),
	get_node("JustVisiting"),
	get_node("Miller Road"),
	get_node("Ayr Racecourse"),
	get_node("Esplanade"),
	get_node("Sandgate"),
	get_node("Bus Garage"),
	get_node("King Street"),
	get_node("Community Chest2"),
	get_node("Smith Street"),
	get_node("Academy Street"),
	get_node("Free Parking"),
	get_node("Burns Statue Square"),
	get_node("Chance2"),
	get_node("Nile Court"),
	get_node("Wellington Square"),
	get_node("Ayr Harbour"),
	get_node("Boswell Park"),
	get_node("Kyle Street"),
	get_node("Ayr Beach"),
	get_node("Beresford Terrace"),
	get_node("GoTOJail"),
	get_node("Newmarket Street"),
	get_node("Alloway Street"),
	get_node("Community Chest3"),
	get_node("High Street"),
	get_node("Newton On Ayr Station"),
	get_node("Chance3"),
	get_node("Park Circus"),
	get_node("Super Tax"),
	get_node("Racecourse Road")]
	
	print(positions)
	print(positions[0].get_translation())
	#Get list of players and span a figure for each of them on the field
	#TODO sollte vielleicht global gespeichert werden, keine gute loesung
	var players = get_node("/root/global").players
	for player in players:
		var figure_instance = figure.instance()
		figure_instance.set_name(player["name"])
		add_child(figure_instance)
		put_player_on_field(player["name"],0)
	set_fixed_process(true)


func _fixed_process(delta):
	pass
#	var player_position = get_node("Die Figur").get_translation()
#	var target_position = get_node("Start").get_translation()
#	
#	if player_position.z < target_position.z:
#		player_position.z = player_position.z + 1 * delta
#	elif player_position.z > target_position.z:
#		player_position.z = player_position.z - 1 * delta
#		
#	if player_position.x < target_position.x:
#		player_position.x = player_position.x + 1 * delta
#	elif player_position.x > target_position.x:
#		player_position.x = player_position.x - 1 * delta
#		
#	get_node("Die Figur").set_translation(player_position)
#

func put_player_on_field(player,field):
	var position  = positions[field].get_position()
	get_node(player).set_translation(position)
	