extends CharacterBody2D
class_name Player

## Player Controller for 2D Side-view Cinematic Adventure
## Phase 1: Basic left/right movement

# Movement settings
@export var walk_speed: float = 150.0
@export var run_speed: float = 300.0
@export var vertical_speed: float = 100.0
@export var acceleration: float = 1000.0
@export var friction: float = 800.0

# State
var is_running: bool = false
var facing_direction: int = 1  # 1 = right, -1 = left

# Node references
@onready var sprite: Sprite2D = $Sprite2D

# 애니메이션 프레임 설정 (Region 방식)
const FRAME_WIDTH = 32
const FRAME_HEIGHT = 32
const IDLE_FRAME = 0
const WALK_START_FRAME = 1
const WALK_FRAMES = 6  # 프레임 1-6만 걷기 (7-12는 공격 모션)

var walk_frame_time: float = 0.0
var current_walk_frame: int = 0


func _ready() -> void:
	print("Player initialized")
	set_sprite_frame(IDLE_FRAME)


func _physics_process(delta: float) -> void:
	handle_input()
	apply_movement(delta)
	update_animation()
	move_and_slide()


func handle_input() -> void:
	"""Handle player input for movement"""
	# 좌우 이동
	var input_direction := Input.get_axis("move_left", "move_right")

	# Update facing direction
	if input_direction != 0:
		facing_direction = sign(input_direction)

	# Determine if running (holding shift)
	is_running = Input.is_action_pressed("ui_shift")

	# Calculate target speed (horizontal)
	var target_speed := 0.0
	if input_direction != 0:
		target_speed = run_speed if is_running else walk_speed
		target_speed *= input_direction

	# Smoothly interpolate velocity (horizontal)
	if input_direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * get_physics_process_delta_time())
	else:
		velocity.x = move_toward(velocity.x, 0, friction * get_physics_process_delta_time())

	# 상하 이동 (상하는 항상 일정 속도)
	var vertical_input := Input.get_axis("move_up", "move_down")
	if vertical_input != 0:
		velocity.y = vertical_speed * vertical_input
	else:
		velocity.y = move_toward(velocity.y, 0, friction * get_physics_process_delta_time())


func apply_movement(delta: float) -> void:
	"""Apply gravity if needed (for future jumping/platforms)"""
	# Currently no gravity - pure horizontal movement
	# Can be added in Phase 2 if needed
	pass


func set_sprite_frame(frame_index: int) -> void:
	"""스프라이트 프레임 설정 (Region 방식)"""
	if not sprite:
		return

	var y_offset = frame_index * FRAME_HEIGHT
	sprite.region_rect = Rect2(0, y_offset, FRAME_WIDTH, FRAME_HEIGHT)


func update_animation() -> void:
	"""Update sprite direction and animation state"""
	if not sprite:
		return

	# Flip sprite based on facing direction
	sprite.flip_h = facing_direction < 0

	# Update animation frames
	if abs(velocity.x) > 10 or abs(velocity.y) > 10:
		# Walking animation
		animate_walk(get_physics_process_delta_time())
	else:
		# Idle animation
		set_sprite_frame(IDLE_FRAME)
		walk_frame_time = 0.0
		current_walk_frame = 0


func animate_walk(delta: float) -> void:
	"""Animate walking frames"""
	walk_frame_time += delta

	# Change frame every 0.1 seconds
	if walk_frame_time >= 0.1:
		walk_frame_time = 0.0
		current_walk_frame = (current_walk_frame + 1) % WALK_FRAMES
		set_sprite_frame(WALK_START_FRAME + current_walk_frame)


func get_facing_direction() -> int:
	"""Returns 1 for right, -1 for left"""
	return facing_direction


func stop_movement() -> void:
	"""Stop player movement (used during dialogues, cutscenes)"""
	velocity = Vector2.ZERO
