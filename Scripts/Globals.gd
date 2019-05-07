extends Node

var players = 0
var stage = "res://stages/FinalDestination.tscn"

func add_player():
	players += 1

func set_stage(stage_path):
	stage = stage_path