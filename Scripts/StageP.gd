extends Node

var stage = ['invisible']

var player
var main

func setup_stagep(player_var, main_var):
	player = player_var
	main = main_var

func get_powerup():
	stage = stage[randi() % stage.size()]
	set_stage()

func set_stage():
	pass