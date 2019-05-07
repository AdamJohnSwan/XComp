extends RigidBody2D

var power_grabbed = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and body.player_dead == false and !power_grabbed:
		body.get_ability_powerup()
		$Bottom.hide()
		$Sprite.hide()
		power_grabbed = true
		$CPUParticles2D.emitting = false
		$Timer.start()


func _on_Timer_timeout():
	queue_free()


func _on_PuffSprite_animation_finished():
	$PuffSprite.hide()
