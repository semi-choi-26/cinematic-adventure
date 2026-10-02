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
@onready var animation_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null


func _ready() -> void:
	print("Player initialized")


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
	# Flip sprite based on facing direction
	if sprite:
		sprite.flip_h = facing_direction < 0

	# Play animations (if AnimationPlayer exists)
	if animation_player:
		if abs(velocity.x) > 10:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("walk")
		else:
			animation_player.play("idle")


func get_facing_direction() -> int:
	"""Returns 1 for right, -1 for left"""
	return facing_direction


func stop_movement() -> void:
	"""Stop player movement (used during dialogues, cutscenes)"""
	velocity = Vector2.ZERO
