extends CanvasLayer

@export var dialogue_path = ""
@export var textSpeed = 0.05
@onready var text = $NinePatchRect/Text
@onready var player = get_tree().get_first_node_in_group("Player")

var dialog
var phrase_num = 0
var finished = false
var kind = null
signal dia_close

func _ready():
	if player:
		# pause player actions
		player.pause_player()
	# init dialog
	dialog = get_dialog()
	if dialog == null:
		dialog = JSON.parse_string('[{"Text":"File Not Found!!"}]')
	text.clear()
	next_phrase()

func _exit_tree():
	# resume player actions
	if player:
		player.resume_player()

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
		var filtered_out = []
		# check if the returned array contains dialogue for the current item kind
		for line in out:
			if line['Name'] == kind:
				filtered_out.append(line)
		if typeof(filtered_out) == TYPE_ARRAY:
			return filtered_out
		return null
		
func next_phrase():
	# if no more phrase to show return
	if phrase_num >= len(dialog):
		queue_free()
		dia_close.emit()
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
		
	
	
