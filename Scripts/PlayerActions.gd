extends Node

const action = [
['player1_jump', 'player1_left', 'player1_right', 'player1_bomb', 'player1_rotate_left', 'player1_rotate_right', 'player1_start'],
['player2_jump', 'player2_left', 'player2_right', 'player2_bomb', 'player2_rotate_left', 'player2_rotate_right', 'player2_start'],
['player3_jump', 'player3_left', 'player3_right', 'player3_bomb', 'player3_rotate_left', 'player3_rotate_right', 'player3_start'],
['player4_jump', 'player4_left', 'player4_right', 'player4_bomb', 'player4_rotate_left', 'player4_rotate_right', 'player4_start']
]

enum {IDLE, RUN, JUMP}
var state
var anim
var new_anim
var facing_left = false

var jump
var left
var right
var select
var rotate_left
var rotate_right
var start

func set_actions(player_number):
	jump = action[player_number][0]
	left = action[player_number][1]
	right = action[player_number][2]
	select = action[player_number][3]
	rotate_left = action[player_number][4]
	rotate_right = action[player_number][5]
	start = action[player_number][6]

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			new_anim = 'idle'
		RUN:
			new_anim = 'run'
		JUMP:
			new_anim = 'jump'

func get_input(player):
	if player.is_on_floor():
		change_state(IDLE)
	player.velocity.x += (player.velocity.x * -1)
	if Input.is_action_pressed(right):
		facing_left = false
		player.velocity.x += player.speed
		if player.velocity.y == 0:
			change_state(RUN)
	if Input.is_action_pressed(left):
		facing_left = true
		player.velocity.x -= player.speed
		if player.velocity.y == 0:
			change_state(RUN)
	if Input.is_action_just_pressed(jump) and player.is_on_floor():
		player.velocity.y = player.jump_speed
		change_state(JUMP)
	if Input.is_action_pressed(rotate_left):
		player.abilitiesgd.rotate_bomb(0.05)
	if Input.is_action_pressed(rotate_right):
		player.abilitiesgd.rotate_bomb(-0.05)
	if Input.is_action_just_pressed(select):
		player.abilitiesgd.handle_bomb()
	player.get_node("Sprite").flip_h = facing_left
	if new_anim != anim:
		anim = new_anim
		player.get_node("Sprite").play(anim)