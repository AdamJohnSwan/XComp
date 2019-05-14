extends CanvasLayer

var countdown = 3

signal countdown_finished

func _ready():
	pass # Replace with function body.

func _on_CountdownAnim():
	countdown -= 1
	$MarginContainer/VBoxContainer/Label.set_text(str(countdown))
	if countdown == 0:
		emit_signal("countdown_finished")
		get_tree().set_pause(false)
