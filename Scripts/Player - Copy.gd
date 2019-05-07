extends KinematicBody2D

export (PackedScene) var Bomb
export (PackedScene) var HUD
export (int) var hearts

var heart_texture = preload("res://assets/images/heart_full.png")
var hud
var bomb
var bomb_set
var rotator
var main
var speed
var jump_speed
var gravity
var player_size
var velocity = Vector2()
var can_take_damage = true
var screen_size

func start(pos):
	position = pos

func _ready():
	screen_size = get_viewport_rect().size
	main = get_tree().get_root().get_node("Main")
	hud = HUD.instance()
	for heart in hearts:
		var heart_image = TextureRect.new()
		heart_image.set_texture(heart_texture) 
		hud.get_node("Container/VBoxContainer/HeartContainer").add_child(heart_image)
	hud.set_position(Vector2(0, screen_size.y - hud.get_node('Container').get_size().y))
	hud.set_position(Vector2(0, 480))
	main.get_node("CanvasLayer").add_child(hud)
	player_size = $Sprite.get_rect().size
	$BodyCollision.disabled = false

func get_input():
	
	velocity.x += (velocity.x * -1)
	var right = Input.is_action_pressed('d')
	var left = Input.is_action_pressed('a')
	var down = Input.is_action_pressed('s')
	var jump = Input.is_action_just_pressed('w')
	
	var select = Input.is_action_just_pressed('ui_select')
	
	var rotate_left = Input.is_action_pressed("ui_left")
	var rotate_right = Input.is_action_pressed("ui_right")
	
	if right:
		velocity.x += speed
	if left:
		velocity.x -= speed
	if jump and is_on_floor():
		velocity.y = jump_speed
	if select:
		if bomb:
			bomb.start_timer() if !bomb_set else 0
			bomb_set = true
		else:
			bomb_set = false
			bomb = Bomb.instance()
			rotator = bomb.get_node("Rotator")
			main.add_child(bomb)
	if rotate_left and bomb and !bomb_set:
		rotator.set_rotation(rotator.get_rotation() + 0.05)
	if rotate_right and bomb and !bomb_set:
		rotator.set_rotation(rotator.get_rotation() - 0.05)

func _process(delta):
	get_input()
	if bomb:
		if !bomb_set:
			bomb.position = Vector2(position.x + (player_size.x / 2), position.y + (player_size.y / 4))
		if bomb.is_countdown:
			bomb.hide()
		if !bomb.is_exploding and bomb.is_countdown:
			bomb.queue_free()
			bomb = null

func _physics_process(delta):
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if position.y > 1400:
		get_tree().reload_current_scene()

func take_damage(damage):
	if can_take_damage:
		$Sprite/HurtAnimation.play('hurt')
		$DamageCooldown.start()
		if velocity.y != 0:
			velocity.y *= -1
		else:
			velocity.y += jump_speed /2
		velocity.y = (abs(velocity.y) + jump_speed) * (velocity.normalized().y * -1)
		velocity.x = (abs(velocity.x) + speed * 25) * (velocity.normalized().x * -1)
		can_take_damage = false
		hearts -= damage
		while damage != 0 and hearts >= 0:
			hud.get_node('Container').get_node('VBoxContainer').get_node('HeartContainer').get_children()[0].queue_free()
			damage -= damage


func _on_DamageCooldown_timeout():
	$Sprite/HurtAnimation.stop()
	can_take_damage = true
