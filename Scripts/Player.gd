extends KinematicBody2D

signal off_screen
signal player_dead

export (PackedScene) var DeathParticles

var PlayerActions = preload("res://Scripts/PlayerActions.gd")
var Abilities = preload("res://Scripts/Abilities.gd")
var Buffs = preload("res://Scripts/Buffs.gd")
var StageP = preload("res://Scripts/StageP.gd")

var player_dead = false
var death_particles
var player_actions
var hud
var main
var speed
var jump_speed
var gravity
var player_size
var velocity = Vector2()
var can_take_damage = true
var screen_size
var hearts
var abilitiesgd
var buffsgd
var stagegd
var color

func _ready():
	player_size = $Sprite.frames.get_frame("idle",0).get_size()
	main = get_tree().get_root().get_node("Main")
	$BodyCollision.disabled = false
	abilitiesgd = Abilities.new()
	buffsgd = Buffs.new()
	stagegd = StageP.new()
	abilitiesgd.setup_abilities(self, main)
	buffsgd.setup_buffs(self, main)
	stagegd.setup_stagep(self, main)
	$Sprite.set_modulate(color)
	connect("off_screen", main, "_on_Player_off_screen", [self])
	connect("player_dead", main, "_on_Player_dead")

func get_actions(number):
	player_actions = PlayerActions.new()
	player_actions.set_actions(number)

func _process(delta):
	if player_dead:
		death_particles.position = position
		death_particles.process_material.set_gravity(Vector3((randi() % 360 + 0) * -1,-100,0))
	else:
		player_actions.get_input(self)
	abilitiesgd.position_bomb()
	buffsgd.position_buff()

func _physics_process(delta):
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if position.y > screen_size.y:
		$RespawnTimer.start() if $RespawnTimer.get_time_left() == 0 else false

func take_damage(damage):
	if buffsgd.bubble:
		buffsgd.pop_bubble()
		can_take_damage = false
		$HurtAnimation.play('hurt')
		$DamageCooldown.start()
		return
	if can_take_damage:
		if velocity.y != 0:
			velocity.y *= -1
		else:
			velocity.y += jump_speed / 2
		velocity.y = (abs(velocity.y) + jump_speed) * (velocity.normalized().y * -1)
		velocity.x = (abs(velocity.x) + main.speed * 25) * (velocity.normalized().x * -1)
		can_take_damage = false
		while damage != 0 and hearts > 0:
			hud.get_node('Container').get_node('VBoxContainer').get_node('HeartContainer').get_children()[hearts - 1].queue_free()
			damage -= 1
			hearts -= 1
		if hearts == 0:
			emit_signal("player_dead")
			$DeathAnimation.play("death")
			death_particles = DeathParticles.instance()
			death_particles.set_modulate(color)
			main.add_child(death_particles)
			set_collision_mask_bit(0, false)
			set_collision_layer_bit(0, false)
			player_actions.change_state('idle')
			player_dead = true
		else:
			$HurtAnimation.play('hurt')
			$DamageCooldown.start()

func _on_DamageCooldown_timeout():
	$HurtAnimation.stop()
	$DamageCooldown.set_wait_time(1)
	can_take_damage = true

func _on_MultiBombTimer_timeout():
	abilitiesgd.set_multi_bomb()

func _on_RespawnTimer_timeout():
	emit_signal("off_screen")

func get_ability_powerup():
	abilitiesgd.get_powerup()

func get_buff_powerup():
	buffsgd.get_powerup()

func get_stage_powerup():
	stagegd.get_powerup()

func _on_DeathAnimation_animation_finished(anim_name):
		if anim_name == "death":
			death_particles.emitting = false
