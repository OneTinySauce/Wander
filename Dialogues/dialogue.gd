extends CanvasLayer

@export var dialogue_path = ""
@export var textSpeed = 0.05
@onready var text = $NinePatchRect/Text
@onready var player = get_tree().get_first_node_in_group("Player")

var dialog
var phrase_num = 0
var finished = false

func _ready():
	# pause player actions
	player.set_process_input(false)
	# init dialog
	dialog = get_dialog()
	if dialog == null:
		dialog = JSON.parse_string('[{"Text":"File Not Found!!"}]')
	text.clear()
	next_phrase()

func _exit_tree():
	# resume player actions
	player.set_process_input(true)

func _process(delta):
	# continue to next phrase if space pressed
	if Input.is_action_just_pressed("ui_accept"):
		# check if current paragraph is under printing
		if finished:
			next_phrase()
		else:
			# show full paragraph if space pressed
			text.visible_characters = len(text.text)
		return
		
func get_dialog():
	# read the path of dialog json file into array
	var file = FileAccess.open(dialogue_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		var out = JSON.parse_string(json)
		if typeof(out) == TYPE_ARRAY:
			return out
		return null
		
func next_phrase():
	# if no more phrase to show return
	if phrase_num >= len(dialog):
		queue_free()
		return
		
	# strat a new print
	finished = false
	
	text.text = dialog[phrase_num]["Text"]
	#text.text.add_text(dialog[phrase_num]["Text"])
	text.visible_characters = 0
	
	# print char one by one with textSpeed(in sec)
	while text.visible_characters < len(text.text):
		text.visible_characters += 1
		await get_tree().create_timer(textSpeed).timeout
	
	finished = true
	phrase_num += 1
	return
		
	
	
