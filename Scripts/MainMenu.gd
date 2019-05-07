extends TextureRect

var check = preload('res://assets/images/check_mark.png')

var player1_entered = true
var player2_entered
var player3_entered
var player4_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node('Player1/NinePatchRect/HBoxContainer/TextureRect').set_texture(check)
	Globals.add_player()

func check_for_player_enter():
	var player1_enter = Input.is_action_just_pressed("player1_start") 
	var player2_enter = Input.is_action_just_pressed("player2_start")
	var player3_enter = Input.is_action_just_pressed("player3_start")
	var player4_enter = Input.is_action_just_pressed("player4_start")
	
	if player1_enter and !player1_entered:
		player1_entered = true
		$PlayerEnter.play()
		get_node('Player1/NinePatchRect/HBoxContainer/TextureRect').set_texture(check)
		Globals.add_player()
	if player2_enter and !player2_entered:
		player2_entered = true
		$PlayerEnter.play()
		get_node('Player2/NinePatchRect/HBoxContainer/TextureRect').set_texture(check)
		Globals.add_player()
	if player3_enter and !player3_entered:
		player3_entered = true
		$PlayerEnter.play()
		get_node('Player3/NinePatchRect/HBoxContainer/TextureRect').set_texture(check)
		Globals.add_player()
	if player4_enter and !player4_entered:
		player4_entered = true
		$PlayerEnter.play()
		get_node('Player4/HBoxContainer/TextureRect').set_texture(check)
		Globals.add_player()

func _process(delta):
	check_for_player_enter()


func _on_StartButton_pressed():
	$GameStart.play()
	SceneChanger.fade_to("res://StageSelect.tscn")
