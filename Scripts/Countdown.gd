extends CanvasLayer

var countdown = 3

signal countdown_finished

func _ready():
	#remove when ready
	queue_free()
	#get_tree().set_pause(true)
	#$countdown.play()

func _on_CountdownAnim():
	countdown -= 1
	$MarginContainer/VBoxContainer/Label.set_text(str(countdown))
	if countdown == 0:
		$start.play()
		$Timer.start()
		$Go.show()
		$MarginContainer.hide()
		$Panel.hide()
		get_tree().set_pause(false)
	else:
		$countdown.play()


func _on_Timer_timeout():
	queue_free()
