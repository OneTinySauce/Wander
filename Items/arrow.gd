extends Sprite2D

@export var dialog_path = "res://Dialogues/items.json"
var player_enter = false

func _ready():
	pass

func _input(event):
	# check player enter the item, dialog preesed and no dialogue currently
	if player_enter and Input.is_action_just_pressed('dialog') and not is_dialogue():
		var dia_scene = load("res://Dialogues/dialogue.tscn")
		var dia = dia_scene.instantiate()
		dia.dialogue_path = dialog_path
		dia.is_inside_tree()
		add_child(dia)


func is_dialogue():
	return get_tree().get_nodes_in_group('dialogue').size() > 0


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_enter = true
		print("Entered")
		print(self.get_path())


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_enter = false
		print("exited")
