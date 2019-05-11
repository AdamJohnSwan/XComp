extends Control

func _process(delta):
	if Input.is_action_just_pressed('player1_start'):
		if get_tree().is_paused():
			get_tree().set_pause(false)
			hide()
		else:
			get_tree().set_pause(true)
			show()
