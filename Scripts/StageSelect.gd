extends TextureRect

var files = []
var thumbs = []
var stage_dir = "res://stages/"
var Thumbnail = preload("res://StageThumbnail.tscn")

func _ready():
	var dir = Directory.new()
	var file_obj = File.new()
	dir.open(stage_dir)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			thumbs.append(Thumbnail.instance())
	
	var index = 0
	for file in files:
		#TODO: Search files in stages folder and display them
#		file_obj.open(stage_dir + file, 1)
#		thumbs[index].get_node("VboxContainer/Panel/Label").set_text(file_obj.get_path_absolute())
#		$HBoxContainer.add_child(thumbs[index])
#		file_obj.close()
		index += 1




func _on_DestinationButton_pressed():
	Globals.set_stage("res://stages/FinalDestination.tscn")
	SceneChanger.fade_to("res://Main.tscn")

func _on_TunnelButton_pressed():
	Globals.set_stage("res://stages/Tunnel.tscn")
	SceneChanger.fade_to("res://Main.tscn")
