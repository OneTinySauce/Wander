extends Button


func _on_pressed():
	var tree = get_tree()
	tree.change_scene_to_file("res://Levels/level_0.tscn")
