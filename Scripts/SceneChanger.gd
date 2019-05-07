extends CanvasLayer

# STORE THE SCENE PATH
var path = ""


# PUBLIC FUNCTION. CALLED WHENEVER YOU WANT TO CHANGE SCENE
func fade_to(scn_path):
	path = scn_path # store the scene path
	get_node("ColorRect").show()
	get_node("ColorRect/AnimationPlayer").play("fade")
	
# PRIVATE FUNCTION. CALLED AT THE MIDDLE OF THE TRANSITION ANIMATION
func change_scene():
	if path != "":
		get_tree().change_scene(path)

func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("ColorRect").hide()
