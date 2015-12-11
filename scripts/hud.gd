
extends Node2D

var restInterface = load("res://scripts/http.gd")

func _ready():
	# Initialization here
	pass

func displayRoll():
	var dice = Sprite.new().set_texture(load("res://assets/sprites/dice/1_dot"))
	dice.set_centered(true)
	add_child(dice)

