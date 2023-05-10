#Shared script for levels
extends Node2D

var transition_scene = preload("res://Misc/fade_out_from_color.tscn")

func _ready():
	#Set a background color
	RenderingServer.set_default_clear_color(Color.hex(0x0d2b45ff))
	var transition_scene_instance = transition_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
	add_child(transition_scene_instance)
