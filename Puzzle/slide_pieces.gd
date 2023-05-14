extends Sprite2D

var player_enter = false
var col_idx = 0
var row_idx = 0
var moving = false
var moving_to_x = 0
var moving_to_y = 0
signal moved(piece)
signal move_finished

func _ready():
	pass

func _input(event):
	# check player enter the item, dialog preesed and no dialogue currently
	if player_enter and not moving and Input.is_action_just_pressed('dialog'):
		moving = true
		moved.emit(self)

func _physics_process(delta):
	if moving:
		if self.position.x < moving_to_x:
			self.position.x += 1
		else:
			self.position.x -= 1
		if self.position.y < moving_to_y:
			self.position.y += 1
		else:
			self.position.y -= 1
		if self.position.x == moving_to_x and self.position.y == moving_to_y:
			moving = false
			move_finished.emit()

func move():
	print("move x form ", self.position.x, " to ",moving_to_x)
	print("move y form ", self.position.y, " to ",moving_to_y)
	var music = randi_range(0,1)
	if music:
		$move1.play()
	else:
		$move2.play()
	if self.position.x != moving_to_x or self.position.y != moving_to_y:
		moving = true

func shake():
	$AnimationPlayer.play("shake")
	moving = false
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_enter = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_enter = false
