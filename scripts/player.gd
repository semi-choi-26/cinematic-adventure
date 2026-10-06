extends CharacterBody2D
class_name Player

## Player Controller for 2D Side-view Cinematic Adventure

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

# 애니메이션 텍스처
var idle_texture: Texture2D
var walk_textures: Array[Texture2D] = []
var current_walk_frame: int = 0
var walk_frame_time: float = 0.0


func _ready() -> void:
	# AtlasTexture 로드
	idle_texture = sprite.texture

	# Walk 텍스처들 (나중에 추가 가능)
	print("Player initialized")


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

	# 달리기 비활성화 (일단 걷기만)
	is_running = false

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
	pass


func update_animation() -> void:
	"""Update sprite direction and animation state"""
	if not sprite:
		return

	# Flip sprite based on facing direction
	sprite.flip_h = facing_direction < 0

	# Simple idle for now
	# TODO: Add walk animation


func get_facing_direction() -> int:
	"""Returns 1 for right, -1 for left"""
	return facing_direction


func stop_movement() -> void:
	"""Stop player movement (used during dialogues, cutscenes)"""
	velocity = Vector2.ZERO
