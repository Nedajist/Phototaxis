extends Node3D

var player: CharacterBody3D
@onready var front_node = $FrontNode
@onready var back_node = $BackNode
var facing_back: bool = false

func _ready():
	player = get_parent().player_character

func _physics_process(delta):
	var front_distance = player.global_position - front_node.global_position
	var back_distance = player.global_position - back_node.global_position
	if back_distance.length() < front_distance.length() and !facing_back:
		$MothBack.visible = true
		$MothFront.visible = false
		facing_back = true
		#print("FaceBack")
		print(back_distance.length(), "   ", front_distance.length())
	elif back_distance.length() > front_distance.length() and facing_back:
		$MothFront.visible = true
		$MothBack.visible = false
		facing_back = false
		#print("FaceFront")
