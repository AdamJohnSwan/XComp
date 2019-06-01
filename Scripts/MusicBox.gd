extends Control

onready var tween_out = get_node("Tween")

var transition_duration = 3.00
var transition_type = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func fade_out():
	# tween music volume down to 0
	tween_out.interpolate_property($AudioStreamPlayer, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

func _on_TweenOut_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
    object.stop()
