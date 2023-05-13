extends Sprite2D

@export var dialog_path = "res://Dialogues/items.json"
@onready var player = get_tree().get_first_node_in_group('Player')
var player_enter = false
var item_enter = false
var placed_item = null
var per_placed_item = null

var currently_placed_item = null #item currently on pedestal
var solved = false #prevents the player from altering the pedestal after finishing the puzzle

signal puzzle_sloved
signal puzzle_wrong

func _ready():
	pass

func _input(event):
	# check player enter the item, dialog preesed and no dialogue currently
	if player_enter and Input.is_action_just_pressed('dialog') and not is_dialogue():
		var dia_scene = load("res://Dialogues/dialogue.tscn")
		var dia = dia_scene.instantiate()
		dia.kind = get_name().rstrip("0123456789")
		dia.dialogue_path = dialog_path
		dia.is_inside_tree()
		add_child(dia)
	if placed_item and Input.is_action_just_pressed("grab") and player_enter and currently_placed_item != null and not solved:
		placed_item.position.x = self.position.x + randi_range(-16, 16)
		placed_item.position.y = self.position.y - randi_range(8, 16)
		placed_item = null
		currently_placed_item = null

	if placed_item and Input.is_action_just_released("grab"):
		if solved:
			pass
		else:
			if currently_placed_item != null:
				currently_placed_item.position.x = self.position.x + randi_range(-16, 16)
				currently_placed_item.position.y = self.position.y - randi_range(8, 16)
				currently_placed_item = null
			placed_item.position.x = self.position.x
			placed_item.position.y = self.position.y - 8
			placed_item.z_index = 3
			placed_item.pedestal_plaed()
			currently_placed_item = placed_item
			# if item placed is correct emit
			if per_placed_item != placed_item:
				if placed_item.get_name() == "SkullPickable":
					puzzle_sloved.emit()
					solved = true
				else:
					puzzle_wrong.emit()
				per_placed_item = placed_item

func is_dialogue():
	return get_tree().get_nodes_in_group('dialogue').size() > 0


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_enter = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_enter = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("PlaceableItem"):
		print("Item Enterd")
		item_enter = true
		placed_item = area.get_parent()


func _on_area_2d_area_exited(area):
	if area.is_in_group("PlaceableItem") and area.get_parent() == placed_item:
		placed_item.pedestal_placed = false
		placed_item = null
