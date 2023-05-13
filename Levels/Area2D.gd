extends Area2D

@onready var anim = $LevelTransitionAnim
@export var to_level_path = ""
@onready var player = get_tree().get_first_node_in_group("Player")

signal level_changed #we might need this if we make a singleton to save progress? Prelay: I think so if we do save system


func _on_body_entered(body):
	if body.is_in_group("Player"):
		anim.play("TransitionStart")
		player.pause_player()
		await anim.animation_finished
		player.resume_player()
		emit_signal("level_changed")
		get_tree().change_scene_to_file(to_level_path)
