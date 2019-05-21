extends Node2D

export (int) var speed
export (int) var gravity
export (int) var jump_speed
export (int) var hearts

export (PackedScene) var Player
export (PackedScene) var HUD
export (PackedScene) var  BuffPowerup
export (PackedScene) var  AbilityPowerup

var stage = load(Globals.stage)
var map
var heart_texture = preload("res://assets/images/heart_full.png")

const powerup_types = ['ability', 'buff']
var powerup_spawner_locations
var screen_size
var players_left

func _ready():
	map = stage.instance()
	add_child(map)
	powerup_spawner_locations = map.get_node("PowerupSpawnerLocations").get_children()
	Globals.players = 2
	players_left = Globals.players
	screen_size = get_viewport_rect().size
	var player_count = Globals.players
	var index = 0
	while index != player_count:
		var player = Player.instance()
		#set the players screen_size relative to camera zoom
		player.screen_size = screen_size * map.get_node("Camera2D").zoom
		#set player colors
		player.color = Globals.colors[index]
		player.speed = speed
		player.jump_speed = jump_speed
		player.gravity = gravity
		player.get_actions(index)
		player.position = map.get_node('StartingPositions').get_children()[index].position
		$Players.add_child(player)
		var hud = HUD.instance()
		for heart in hearts:
			var heart_image = TextureRect.new()
			heart_image.set_texture(heart_texture) 
			hud.get_node("Container/VBoxContainer/HeartContainer").add_child(heart_image)
		var hud_size = hud.get_node('Container').get_size()
		var hud_position = get_hud_position(index, hud_size)
		hud.set_position(hud_position)
		get_node("CanvasLayer").add_child(hud)
		player.hearts = hearts
		player.hud = hud
		index += 1

func get_hud_position(player_number, hud_size):
	match player_number:
		0:
			return Vector2(1, 1)
		1:
			return Vector2(screen_size.x - (hud_size.x + hearts * 16), 1)
		2:
			return Vector2(1, screen_size.y - hud_size.y - 20)
		3:
			return Vector2(screen_size.x - (hud_size.x + hearts * 16), screen_size.y - hud_size.y - 20)

func _on_PowerupTimer_timeout():
	var powerup_picker = powerup_types[randi() % powerup_types.size()]
	var powerup
	match powerup_picker:
		'ability':
			powerup = AbilityPowerup.instance()
		'buff':
			powerup = BuffPowerup.instance()
	add_child(powerup)
	var location = powerup_spawner_locations[randi() % powerup_spawner_locations.size()]
	location.get_node("PowerupLocation").set_offset(randi())
	powerup.position = location.get_node("PowerupLocation").position
	powerup.get_node('PuffSprite').play('puff')
	$PowerupTimer.set_wait_time(randi() % 30 + 10)
	$PowerupTimer.start()

func _on_Player_off_screen(player):
	player.get_node("DamageCooldown").set_wait_time(3)
	player.take_damage(1)
	if player.hearts > 0:
		player.velocity = Vector2(0,0)
		player.get_node("PuffSprite").show()
		player.get_node("PuffSprite").set_frame(1)
		player.get_node("PuffSprite").play("puff")
		var location = powerup_spawner_locations[randi() % powerup_spawner_locations.size()]
		location.get_node("PowerupLocation").set_offset(randi())
		player.position = location.get_node("PowerupLocation").position
		
func _on_Player_dead():
	if Globals.players == 1:
		Engine.set_time_scale(0.4)
		$EndgameSlowdown.start()
	else:
		players_left -= 1
		if players_left == 1:
			Engine.set_time_scale(0.4)
			$EndgameSlowdown.start()

func _on_EndgameSlowdown_timeout():
	Engine.set_time_scale(1.0)
	#find the winner
	var index = 0
	for player in $Players.get_children():
		if !player.player_dead:
			Globals.winner = index
		index += 1
	SceneChanger.fade_to("res://Results.tscn")