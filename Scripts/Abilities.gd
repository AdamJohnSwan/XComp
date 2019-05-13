extends Node
var Bomb = preload("res://Bomb.tscn")
var hurty_texture = preload("res://assets/images/bombs/hurty.png")
var big_texture = preload("res://assets/images/bombs/big.png")
var multi_texture = preload("res://assets/images/bombs/multi.png")
var pointy_texture = preload("res://assets/images/bombs/claymore.png")
var regular_texture = preload("res://assets/images/bombs/bomb.png")
var bomb
var bomb_set
var ability
var bomb_texture
var player
var main
var rotator

#const abilities = ['multi', 'hurty', 'big', 'pointy']
const abilities = ['pointy']
var multi_amount = 0
var multi_rotator
var scale
var damage
var explosion_degree_of_rotation

func setup_abilities(player_var, main_var):
	player = player_var
	main = main_var
	normalize_bomb()

func get_powerup():
	ability = abilities[randi() % abilities.size()]
	set_ability()
	
func handle_bomb():
	if bomb:
		bomb.start_timer() if !bomb_set else 0
		bomb_set = true
		if multi_amount > 0:
			player.get_node("MultiBombTimer").start()
			multi_rotator = bomb.get_rotation()
	else:
		bomb = Bomb.instance()
		main.add_child(bomb)
		rotator = bomb.get_node("Rotator")
		bomb.explosion_degree_of_rotation = explosion_degree_of_rotation
		bomb_set = false
		bomb.explosion_scale = scale
		bomb.damage = damage
		
func position_bomb():
	if bomb:
		if !bomb_set:
			if player.player_actions.facing_left:
				bomb.position = Vector2(player.position.x - (player.player_size.x / 2), player.position.y)
				bomb.explosion_degree_of_rotation = abs(bomb.explosion_degree_of_rotation) * -1
			else:
				bomb.position = Vector2(player.position.x + (player.player_size.x / 2), player.position.y)
				bomb.explosion_degree_of_rotation = abs(bomb.explosion_degree_of_rotation)
			
		if !bomb.is_exploding and bomb.is_countdown:
			normalize_bomb()
			bomb.queue_free()
			bomb = null

func rotate_bomb(direction):
	if !bomb_set and bomb:
		rotator.set_rotation(rotator.get_rotation() + direction)

func set_multi_bomb():
		var multi_bomb = Bomb.instance()
		main.add_child(multi_bomb)
		multi_bomb.get_node("Rotator").set_rotation(multi_rotator)
		multi_bomb.position = Vector2(player.position.x + (player.player_size.x / 2), player.position.y + (player.player_size.y / 4))
		multi_bomb.explosion_scale = 1
		multi_bomb.damage = 1
		multi_bomb.start_timer()
		if multi_amount > 0:
			player.get_node("MultiBombTimer").start()
			multi_amount -= 1
		
func set_ability():
	match ability:
		'big':
			scale = 3
			player.hud.get_node("Icon").set_texture(big_texture)
		'hurty':
			damage = 2
			player.hud.get_node("Icon").set_texture(hurty_texture)
		'multi':
			multi_amount = 1
			player.hud.get_node("Icon").set_texture(multi_texture)
		'pointy':
			explosion_degree_of_rotation = 60
			player.hud.get_node("Icon").set_texture(pointy_texture)
	if bomb:
		bomb.explosion_scale = scale
		bomb.damage = damage

func normalize_bomb():
	scale = 1
	damage = 1
	explosion_degree_of_rotation = 90
	if player.hud:
		player.hud.get_node("Icon").set_texture(regular_texture)