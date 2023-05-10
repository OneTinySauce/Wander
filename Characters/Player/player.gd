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



func _ready():
	animationTree.active = true
	# at start facing down
	animationTree.set("parameters/Idle/blend_position", START_POSTION)

func _physics_process(delta):
	# Get input strength as a Vector2
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()

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
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
