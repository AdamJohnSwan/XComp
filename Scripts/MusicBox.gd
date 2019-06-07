extends Control

onready var tween_out = get_node("Tween")

var music_dir = "res://assets/music/"
var transition_duration = 3.00
var transition_type = 1

func _ready():
	randomize()
	#pick a random music track
	var dir = Directory.new()
	var file_obj = File.new()
	var tracks = []
	
	dir.open(music_dir)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".ogg"):
			tracks.append(file)
	
	var music_file = randi() % tracks.size()
	var music = load(music_dir + tracks[music_file])
	music.set_loop(true)
	$AudioStreamPlayer.set_stream(music)
	pass

func fade_out():
	# tween music volume down to 0
	tween_out.interpolate_property($AudioStreamPlayer, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

func _on_TweenOut_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
    object.stop()
