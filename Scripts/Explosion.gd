extends Area2D

var damage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Explosion_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage)
