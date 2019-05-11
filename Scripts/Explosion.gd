extends Node2D

var scale_of_explosion = 0
var explosion_sizer = 5000
var shape_size
var damage = 1
var explosion_degree_of_rotation = 60

func _on_Explosion_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage)

func _ready():
	var index = 0
	var rot_degrees = 0
	var shapes = get_children()
	while (index < get_child_count()):
		shapes[index].set_rotation(deg2rad(rot_degrees))
		rot_degrees -= explosion_degree_of_rotation
		shape_size = shapes[index].get_size()
		index += 1

func _process(delta):
	scale_of_explosion += explosion_sizer * delta
	for shape in get_children():
		shape.set_size(Vector2(40, scale_of_explosion))
		shape.get_node("Area2D").set_scale(Vector2(1,scale_of_explosion / shape_size.y))