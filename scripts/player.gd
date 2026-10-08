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

# Y 위치 제한
var initial_y: float = 0.0
const MAX_UP_DISTANCE: float = 0.0
const MAX_DOWN_Y: float = 380.0  # 바닥 바로 위 (바닥은 y=400)

# Node references
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	# 초기 Y 위치 저장
	initial_y = global_position.y

	# 기본 애니메이션
	animated_sprite.play("idle")

	print("Player initialized at Y:", initial_y)


func _physics_process(delta: float) -> void:
	handle_input()
	apply_movement(delta)
	update_animation()
	move_and_slide()

	# Y 위치 제한
	# 위로 20px만
	if global_position.y < initial_y - MAX_UP_DISTANCE:
		global_position.y = initial_y - MAX_UP_DISTANCE
		velocity.y = 0

	# 아래로는 바닥까지만 (화면 하단)
	if global_position.y > MAX_DOWN_Y:
		global_position.y = MAX_DOWN_Y
		velocity.y = 0


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
	if not animated_sprite:
		return

	# Flip sprite based on facing direction
	animated_sprite.flip_h = facing_direction < 0

	# 이동 중인지 확인
	var is_moving = abs(velocity.x) > 10 or abs(velocity.y) > 10

	if is_moving:
		# 걷기 애니메이션
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
	else:
		# 대기 애니메이션
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")


func get_facing_direction() -> int:
	"""Returns 1 for right, -1 for left"""
	return facing_direction


func stop_movement() -> void:
	"""Stop player movement (used during dialogues, cutscenes)"""
	velocity = Vector2.ZERO
	if animated_sprite:
		animated_sprite.play("idle")
