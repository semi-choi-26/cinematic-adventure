extends CharacterBody2D
class_name Player

## Player Controller for 2D Side-view Cinematic Adventure
## Phase 1: Basic left/right movement

# Movement settings
@export var walk_speed: float = 150.0
@export var run_speed: float = 300.0
@export var acceleration: float = 1000.0
@export var friction: float = 800.0

# State
var is_running: bool = false
var facing_direction: int = 1  # 1 = right, -1 = left

# Node references
@onready var sprite: Sprite2D = $Sprite2D

# 애니메이션 프레임 설정
const IDLE_FRAME = 0
const WALK_START_FRAME = 1
const WALK_END_FRAME = 7
const WALK_FRAMES = 7

var walk_frame_time: float = 0.0
var current_walk_frame: int = 0


func _ready() -> void:
	print("Player initialized")
	sprite.frame = IDLE_FRAME


func _physics_process(delta: float) -> void:
	handle_input()
	apply_movement(delta)
	update_animation()
	move_and_slide()


func handle_input() -> void:
	"""Handle player input for movement"""
	var input_direction := Input.get_axis("move_left", "move_right")

	# Update facing direction
	if input_direction != 0:
		facing_direction = sign(input_direction)

	# Determine if running (holding shift)
	is_running = Input.is_action_pressed("ui_shift")

	# Calculate target speed
	var target_speed := 0.0
	if input_direction != 0:
		target_speed = run_speed if is_running else walk_speed
		target_speed *= input_direction

	# Smoothly interpolate velocity
	if input_direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * get_physics_process_delta_time())
	else:
		velocity.x = move_toward(velocity.x, 0, friction * get_physics_process_delta_time())


func apply_movement(delta: float) -> void:
	"""Apply gravity if needed (for future jumping/platforms)"""
	# Currently no gravity - pure horizontal movement
	# Can be added in Phase 2 if needed
	pass


func update_animation() -> void:
	"""Update sprite direction and animation state"""
	if not sprite:
		return

	# Flip sprite based on facing direction
	sprite.flip_h = facing_direction < 0

	# Update animation frames
	if abs(velocity.x) > 10:
		# Walking animation
		animate_walk(get_physics_process_delta_time())
	else:
		# Idle animation
		sprite.frame = IDLE_FRAME
		walk_frame_time = 0.0
		current_walk_frame = 0


func animate_walk(delta: float) -> void:
	"""Animate walking frames"""
	walk_frame_time += delta

	# Change frame every 0.1 seconds
	if walk_frame_time >= 0.1:
		walk_frame_time = 0.0
		current_walk_frame = (current_walk_frame + 1) % WALK_FRAMES
		sprite.frame = WALK_START_FRAME + current_walk_frame


func get_facing_direction() -> int:
	"""Returns 1 for right, -1 for left"""
	return facing_direction


func stop_movement() -> void:
	"""Stop player movement (used during dialogues, cutscenes)"""
	velocity = Vector2.ZERO
