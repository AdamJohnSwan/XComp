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
var explosion_degree_of_rotation = 60
var prev_explosion_rotation
func _ready():
	is_countdown = false
	

func _process(delta):
	#only set the rotation if the direction of the player has changed
	if prev_explosion_rotation != explosion_degree_of_rotation:
		#set position of arrows
		var index = 0
		var arrow_rotation = 0
		var arrows = $Rotator.get_children()
		while index < arrows.size():
			arrows[index].set_rotation(deg2rad(arrow_rotation))
			arrow_rotation += explosion_degree_of_rotation
			index +=1
	if is_exploding:
		if explosion.scale_of_explosion >= 1200:
			is_exploding = false
			explosion.queue_free()
	prev_explosion_rotation = explosion_degree_of_rotation

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
	explosion.explosion_degree_of_rotation = explosion_degree_of_rotation
	main.add_child(explosion)
	explosion.position = position

func _on_PulseTimer_timeout():
	$PulseTimer.start()
	$Sprite/AnimationPlayer.play('pulse')
