extends CanvasLayer

var dialog_path = "res://Dialogues/narrator.json"

func _ready():
	var dia_scene = load("res://Dialogues/dialogue.tscn")
	var dia = dia_scene.instantiate()
	dia.kind = "End"
	dia.dialogue_path = dialog_path
	dia.is_inside_tree()
	add_child(dia)


func _on_dialogue_child_exiting_tree(node):
	$AnimationPlayer.play("Text")
	$endBGM.play()
