#Shared script for levels
extends Node2D

var transition_scene = preload("res://Misc/fade_out_from_color.tscn")
var is_sloved = false

func _ready():
	#Set a background color
	RenderingServer.set_default_clear_color(Color.hex(0x0d2b45ff))
	var transition_scene_instance = transition_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
	add_child(transition_scene_instance)

func _on_pedestal_puzzle_sloved():
	if not is_sloved:
		is_sloved = true
		$puzzle_solved.play()
		$PuzzleDoor.open()

func _on_pedestal_puzzle_wrong():
	if !$puzzle_fail.is_playing():
		$puzzle_fail.play()
