extends NinePatchRect

@export var dialogue_path = ""
@export var textSpeed = 0.05
@onready var text = $Text

var dialog
var phrase_num = 0
var finished = false

func _ready():
	# init dialog
	dialog = get_dialog()
	text.clear()
	next_phrase()

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
	var json = file.get_as_text()
	var out = JSON.parse_string(json)
	if typeof(out) == TYPE_ARRAY:
		return out
	else:
		return []
	
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
		
	
	
