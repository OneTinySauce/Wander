extends CanvasLayer

var dialog_path = "res://Dialogues/narrator.json"

var end = false

func _ready():
	var dia_scene = load("res://Dialogues/dialogue.tscn")
	var dia = dia_scene.instantiate()
	dia.kind = "End"
	dia.dialogue_path = dialog_path
	dia.is_inside_tree()
	add_child(dia)
	$"roll credit".hide()
	$Crown.hide()
	$Mc.hide()
	$Throne.hide()

func _input(event):
	if get_tree().get_nodes_in_group('dialogue').size() == 0:
		end = true
		ending()
		self.set_process_input(false)

func ending():
	if end:
		$"roll credit".show()
		$Crown.show()
		$Mc.show()
		$Throne.show()
		end = false
		$AnimationPlayer.play("Text")
		$endBGM.play()
