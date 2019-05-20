extends MarginContainer


func _ready():
	var index = 0
	while index < Globals.players:
		if index < 2:
			var box = $VBoxContainer/TopRow.get_children()[index].get_node("ColorRect")
			box.show()
			if Globals.winner == index:
				box.get_node("Crown").show()
			else:
				box.get_node("Skull").show()
		if index >= 2:
			var box = $VBoxContainer/BottomRow.get_children()[index - 2].get_node("ColorRect")
			box.show()
			if Globals.winner == index:
				box.get_node("Crown").show()
			else:
				box.get_node("Skull").show()
		index += 1


func _on_ReturnButton_pressed():
	SceneChanger.fade_to("res://MainMenu.tscn")
