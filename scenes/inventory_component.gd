class_name InventoryComponent
extends Node3D
@onready var gasoline_audio_stream_player_3d: AudioStreamPlayer3D = %GasolineAudioStreamPlayer3D
@onready var mothster_audio_stream_player_3d: AudioStreamPlayer3D = %MothsterAudioStreamPlayer3D
@onready var pickup_audio_stream_player_3d: AudioStreamPlayer3D = %PickupAudioStreamPlayer3D

var has_mothster = false
var has_gasoline = false

func _ready() -> void:
	EventBus.gasoline_attempt_pickup.connect(gasoline_attempt_pickup)
	EventBus.mothster_attempt_pickup.connect(mothster_attempt_pickup)
	EventBus.generator_interacted.connect(generator_interacted)

func _process(_delta) -> void:
	if Input.is_action_just_pressed("right_click"):
		if has_mothster:
			EventBus.mothster_used.emit()
			mothster_audio_stream_player_3d.play()
			has_mothster = false

func mothster_attempt_pickup(mothster:MothsterEnergy):
	if(!has_mothster):
		pickup_audio_stream_player_3d.play()
		has_mothster = true
		EventBus.mothster_picked_up.emit()
		mothster.destroy()
	
func gasoline_attempt_pickup(gasoline:GasolineCanister):
	if(!has_gasoline):
		pickup_audio_stream_player_3d.play()
		has_gasoline = true
		EventBus.gasoline_picked_up.emit()
		gasoline.destroy()
		
func generator_interacted():
	if(has_gasoline):
		gasoline_audio_stream_player_3d.play()
		EventBus.generator_filled_with_gas.emit()
		has_gasoline = false
		EventBus.gasoline_used.emit()
