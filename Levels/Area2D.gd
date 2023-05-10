extends Area2D

@onready var anim = $LevelTransitionAnim

signal level_changed #we might need this if we make a singleton to save progress?

func _on_body_entered(body):
	if body.is_in_group("Player"):
		anim.play("TransitionStart")
		await anim.animation_finished
		emit_signal("level_changed")
		get_tree().change_scene_to_file("res://Levels/level_1.tscn")
