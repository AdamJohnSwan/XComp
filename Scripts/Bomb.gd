extends Area2D

export (PackedScene) var Explosion

onready var main = get_tree().get_root().get_node("Main")
var explosion
var shapes
var is_countdown
var is_exploding
var scale_of_explosion
var explosion_sizer = 200
var explosion_scale
var damage

func _ready():
	is_countdown = false

func _process(delta):
	if is_exploding:
		if explosion.scale_of_explosion >= 1200:
			is_exploding = false
			explosion.queue_free()

func start_timer():
	is_countdown = false
	$CountdownTimer.start()
	$PulseTimer.start()
	$Sprite/AnimationPlayer.play('pulse')

func _on_CountdownTimer_timeout():
	$ExplosionSound.play()
	scale_of_explosion = 1
	is_exploding = true
	is_countdown = true
	hide()
	explosion = Explosion.instance()
	
	#set ability
	explosion.set_scale(Vector2(explosion_scale, explosion_scale))
	explosion.damage = damage
	
	explosion.set_rotation($Rotator.get_rotation() + explosion.get_rotation())
	main.add_child(explosion)
	explosion.position = position

func _on_PulseTimer_timeout():
	$PulseTimer.start()
	$Sprite/AnimationPlayer.play('pulse')
