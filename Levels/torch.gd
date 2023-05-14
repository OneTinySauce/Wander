extends Sprite2D

var light = false
var player_enter = false
var row_idx = 0
var col_idx = 0
signal toggled(torch)

func _ready():
	if light:
		self.frame = 5
	else:
		self.frame = 4

func toggle():
	if light:
		# turn off
		$lightOff.play()
		self.frame = 4
		light = false
	else:
		$lightOn.play()
		self.frame = 5
		light = true

func _input(event):
	if player_enter and Input.is_action_just_pressed("dialog"):
		toggle()
		toggled.emit(self)

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_enter = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_enter = false
