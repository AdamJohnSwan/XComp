extends Node2D

var scale_of_explosion = 0
var explosion_sizer = 6000
var shape_size
var damage = 1

func _on_Explosion_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage)

func _ready():
	for shape in get_children():
		shape_size = shape.get_size()

func _process(delta):
	scale_of_explosion += explosion_sizer * delta
	for shape in get_children():
		shape.set_size(Vector2(40, scale_of_explosion))
		print(shape.get_size().y)
		shape.get_node("Area2D").set_scale(Vector2(1,scale_of_explosion / shape_size.y))