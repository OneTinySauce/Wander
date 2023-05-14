extends Control

@onready var start_button = $VBoxContainer/Start
@onready var quit_button = $VBoxContainer/Quit
@onready var anim = $AnimationPlayer
@onready var sfx = $SFX

func _ready():
	await anim.animation_finished
	start_button.grab_focus()

func _on_start_pressed():
	anim.queue("StartPressed")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://Levels/level_0.tscn")

func _on_quit_pressed():
	get_tree().quit()
