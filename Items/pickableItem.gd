extends Sprite2D

@export var dialog_path = "res://Dialogues/items.json"
@onready var player = get_tree().get_first_node_in_group('Player')
var player_enter = false
var pedestal_placed = false
var pedestal_placeable = false

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
	if Input.is_action_just_released("grab"):
		pedestal_placeable = true
	if Input.is_action_just_pressed("grab"):
		pedestal_placeable = false


func _physics_process(delta):
	if player_enter and not pedestal_placeable and Input.is_action_pressed("grab"):
		if not player.picked_item or player.picked_item == self:
			self.position.x = player.position.x
			self.position.y = player.position.y - 16
			# reset z index so it appears in front of player
			self.z_index = 3
			player.picked_item = self
	if Input.is_action_just_released("grab"):
		if player.picked_item == self:
			player.picked_item = null
		if not pedestal_placed:
			# reset z index
			self.z_index = 0
		

func is_dialogue():
	return get_tree().get_nodes_in_group('dialogue').size() > 0


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_enter = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_enter = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("PlaceableItem") and pedestal_placeable:
		pedestal_placed = true
		pedestal_placeable = false

func pedestal_plaed():
	pedestal_placed = true
