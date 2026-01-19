extends State
class_name MothEnraged

@export var moth_enemy: CharacterBody3D
@export var move_speed:= 10
@onready var nav_agent: NavigationAgent3D
@onready var player: CharacterBody3D
@onready var musicmanager: Node = $"../../../musicmanager"

var gas_empty = false

var SPEED = randi_range(4,7)

func _ready() -> void:
	EventBus.gas_changed.connect(_on_gas_changed)

func Enter():
	print("Enrage Entered")
	gas_empty = true
	musicmanager._increase_chasing_moths()
	player.camera_lookat_target=moth_enemy

func Exit():
	gas_empty = false
	musicmanager._decrease_chasing_moths()

func Physics_Update(_delta: float):
	if moth_enemy and player:
		moth_enemy.update_target_location(player.global_transform.origin)
		
		var current_location = moth_enemy.global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		moth_enemy.velocity = new_velocity
		moth_enemy.move_and_slide()
		

func _on_gas_changed(value) -> void:
	if (value > 0):
		Transitioned.emit(self, "MothIdle")
