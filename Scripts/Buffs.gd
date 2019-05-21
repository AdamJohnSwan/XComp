extends Node

var Bubble = preload("res://Bubble.tscn")
var Trail = preload("res://Trail.tscn")

var buffs = ['fast', 'slow', 'bubble', 'remote']
var buff_time = 8

var trail
var player
var main
var buff
var bubble
var speed_timer

func setup_buffs(player_var, main_var):
	player = player_var
	main = main_var

func get_powerup():
	buff = buffs[randi() % buffs.size()]
	set_buff()

func set_buff():
	match buff:
		'bubble':
			if !bubble:
				bubble = Bubble.instance()
				main.add_child(bubble)
				main.get_node("bubble_sound").play()
		'remote':
			player.abilitiesgd.bomb_remote = true
			player.get_node("Remote").show()
			main.get_node("remote_sound").play()
		'fast':
			player.speed = main.speed * 2
			player.get_node("Sprite").set_speed_scale(2)
			main.get_node("fast_sound").play()
			if !trail:
				trail = Trail.instance()
				trail.set_trail(player, player.color)
				player.add_child(trail)
			if speed_timer:
				if speed_timer.get_time_left() > 0:
					speed_timer.start()
			else:
				add_speed_timer()
		'slow':
			player.speed = main.speed / 2
			player.get_node("Sprite").set_speed_scale(0.5)
			main.get_node("slow_sound").play()
			if speed_timer:
				if trail:
					trail.get_node("Line2D").hide()
				if speed_timer.get_time_left() > 0:
					speed_timer.start()
			else:
				add_speed_timer()

func add_speed_timer():
	speed_timer = Timer.new()
	speed_timer.set_wait_time(buff_time)
	speed_timer.set_one_shot(true)
	player.add_child(speed_timer)
	speed_timer.start()

func position_buff():
	if bubble:
		bubble.position = player.position
	if speed_timer:
		if speed_timer.get_time_left() == 0:
			player.speed = main.speed
			if trail:
				trail.queue_free()
				trail = null
			speed_timer = null

func pop_bubble():
	bubble.queue_free()
	bubble = null

func _on_speed_timer_timeout():
	player.speed = main.speed
	player.get_node("Sprite").set_speed_scale(1)
	if trail:
		trail.queue_free()
		trail = null
	speed_timer = null