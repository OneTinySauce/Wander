extends CharacterBody2D


const MAX_SPEED = 40
const ACCELERATION = 100
const FRICTION = 300
const RUN_SPEED_SCALE : float = 1.4
const START_POSTION : Vector2 = Vector2(0,1)

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
var speedScale : float = 1.0
var input_vector = Vector2.ZERO
var picked_item = null
var per_item = null

func pause_player():
	# pause the player from moving, and change state to idle
	animationState.travel("Idle")
	self.set_physics_process(false)
	self.set_process_input(false)

func resume_player():
	# resume player actions.
	self.set_physics_process(true)
	self.set_process_input(true)
	
func _ready():
	animationTree.active = true
	# at start facing down
	animationTree.set("parameters/Idle/blend_position", START_POSTION)

func _input(event):
	# Get input strength as a Vector2
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()

func _process(delta):
	if per_item != picked_item:
		if per_item:
			$ItemPlaced.play()
		if picked_item:
			$ItemPickedUp.play()
		per_item = picked_item

func _physics_process(delta):
	# if there's input, move accordingly
	if input_vector != Vector2.ZERO:
		# animation
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/BlendSpace2D/blend_position", input_vector)
		# movement
		velocity = velocity.move_toward(input_vector * MAX_SPEED * (1 + Input.get_action_strength("run")), ACCELERATION * delta)
		# faster animation if shift preesed 
		# +++ WORKING +++
		if Input.get_action_strength("run"):
			speedScale = RUN_SPEED_SCALE
		else:
			speedScale = 1.0
		# Set the animation speed scale according to the speedScale variable
		animationTree.set("parameters/Run/runSpeedScale/scale", speedScale)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()
	pick_state()

func pick_state():
	if(velocity != Vector2.ZERO):
		#if picked_item != null: #todo: make a hold animation for the player
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
