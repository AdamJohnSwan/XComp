extends Node

var player
var point
var trail_length = 30

func set_trail(player_var, color_var):
	player = player_var
	var color_hex = color_var.to_html(false)
	var gradient = Gradient.new()
	gradient.set_color(0, Color("00" + color_hex))
	gradient.set_color(1, Color(color_hex))
	$Line2D.set_gradient(gradient)

func _process(delta):
	point = player.position
	$Line2D.add_point(point)
	while $Line2D.get_point_count() > trail_length:
		$Line2D.remove_point(0)