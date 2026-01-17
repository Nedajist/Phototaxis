class_name Switch
extends Node3D
@onready var animated_hinge: Node3D = %AnimatedHinge
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var active = true
var animation_time = 1

# z rotation of animated_hinge to -90
func animate_switch_off() -> void:
	animation_player.play("switch_off")
	active = false
	pass
	
# z rotation of animated_hinge to 0
func animate_switch_on() -> void:
	animation_player.play("switch_on")
	active = true
	
	pass
