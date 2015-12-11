
extends Sprite

var title = ""
var rent = 0
var withOneHouse = 0
var withTwoHouses = 0
var withThreeHouses = 0
var withFourHouses = 0
var withHotel = 0
var mortage = 0
var houseCost = 0
var hotelCost = 0

func _init():	
	pass

	

	
func _ready():
	pass
	
func get_size():
	return get_texture().get_size()
func setValues(title,rent,withOneHouse,withTwoHouses,withThreeHouses,withFourHouses,withHotel,mortage,houseCost,hotelCost):
	
	self.title = title
	self.rent = rent
	self.withOneHouse = withOneHouse
	self.withTwoHouses = withTwoHouses
	self.withThreeHouses = withThreeHouses
	self.withFourHouses = withFourHouses
	self.withHotel = withHotel
	self.mortage = mortage
	self.houseCost = houseCost
	self.hotelCost = hotelCost
	
	get_node("Title").set_text(title)
	get_node("RentValue").set_text(rent)
	get_node("With1HouseValue").set_text(withOneHouse)
	get_node("With2HousesValue").set_text(withTwoHouses)
	get_node("With3HousesValue").set_text(withThreeHouses)
	get_node("WithHotelValue").set_text(withHotel)
	get_node("MartaguesValue").set_text(mortage)
	get_node("HousesCostValue").set_text(houseCost)
	get_node("HotelCostValue").set_text(hotelCost)
	



