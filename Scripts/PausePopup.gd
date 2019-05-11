extends Control

var player1_start = Input.is_action_just_pressed('player1_start')
var player2_start = Input.is_action_just_pressed('player2_start')
var player3_start = Input.is_action_just_pressed('player3_start')
var player4_start = Input.is_action_just_pressed('player4_start')

func _process(delta):
	if player1_start or player2_start or player3_start or player4_start:
		if get_tree().is_paused():
			get_tree().set_pause(false)
			hide()
		else:
			get_tree().set_pause(true)
			show()
