extends CanvasLayer

var type
var shader_amount = 4

func _ready():
	randomize()
	type = randi() % shader_amount + 1
	$Shader.material.set_shader_param("type", type)

func change_shader():
	var new_type = type
	while new_type == type:
		new_type = randi() % shader_amount + 1
	type = new_type
	$Shader.material.set_shader_param("type", type)

func start_switching():
	$Switcher/AnimationPlayer.play("fade")
