extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Shader.material.set_shader_param("type", 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func start_switcher():
	$CanvasLayer/Switcher/AnimationPlayer.play("fade")

func change_shader():
	pass