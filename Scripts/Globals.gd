extends Node

var players = 0
var winner = 0
var colors = [Color(255,0,0), Color(0,0,255), Color(0,255,0), Color(255,255,0)]
var stage = "res://stages/FinalDestination.tscn"

func add_player():
	players += 1

func set_stage(stage_path):
	stage = stage_path