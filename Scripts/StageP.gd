extends Node

var stage = ['invisible']

var main
var invisibility_tween
var stage_powerup_timer
var invisibility_powerup_timer
var invisibility_time = 5
var powerup_time = 20
var transition_duration = 1.00
var transition_type = 1

func setup_stagep(main_var):
	main = main_var
	stage_powerup_timer = Timer.new()
	stage_powerup_timer.connect("timeout", self, "on_powerup_timer_completed")
	stage_powerup_timer.set_wait_time(powerup_time)
	stage_powerup_timer.set_one_shot(true)
	main.add_child(stage_powerup_timer)

func get_powerup():
	stage = stage[randi() % stage.size()]
	stage_powerup_timer.start()
	match stage:
		"invisible":
			if !invisibility_tween:
				invisibility_tween = Tween.new()
				invisibility_powerup_timer = Timer.new()
				invisibility_powerup_timer.connect("timeout", self, "on_invisbility_timer_completed")
				invisibility_powerup_timer.set_wait_time(invisibility_time)
				invisibility_powerup_timer.set_one_shot(true)
				main.add_child(invisibility_tween)
				main.add_child(invisibility_powerup_timer)
			invisibility_powerup_timer.start()
			on_invisbility_timer_completed()

func play_invisibility_fade_out(player):
	invisibility_tween.interpolate_property(player, "modulate:a", 1, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
	invisibility_tween.start()

func play_invisibility_fade_in(player):
	invisibility_tween.interpolate_property(player, "modulate:a", 0, 1, transition_duration, transition_type, Tween.EASE_OUT, 0)
	invisibility_tween.start()

func on_invisbility_timer_completed():
	invisibility_powerup_timer.start()
	for player in main.get_node("Players").get_children():
		if player.modulate.a == 0:
			play_invisibility_fade_in(player)
		else:
			play_invisibility_fade_out(player)

func on_powerup_timer_completed():
	# normalize stage
	for player in main.get_node("Players").get_children():
		player.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
		if(invisibility_powerup_timer):
			invisibility_powerup_timer.stop()
	pass