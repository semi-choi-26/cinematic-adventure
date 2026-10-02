extends Camera2D
class_name CameraController

## Camera Controller for 2D Side-view Game
## Follows player with smooth tracking and bounds

# Camera settings
@export var follow_speed: float = 5.0
@export var look_ahead_distance: float = 100.0
@export var use_camera_bounds: bool = true

# Camera bounds (set per level)
@export var min_x: float = 0
@export var max_x: float = 2000
@export var min_y: float = -100
@export var max_y: float = 100

# Target to follow
var target: Node2D = null


func _ready() -> void:
	# Find player automatically
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")

	if target:
		global_position = target.global_position
		print("Camera tracking: ", target.name)
	else:
		push_warning("CameraController: No player found in 'player' group")


func _process(delta: float) -> void:
	if not target:
		return

	follow_target(delta)


func follow_target(delta: float) -> void:
	"""Smoothly follow the target with look-ahead"""
	var target_pos := target.global_position

	# Add look-ahead based on player direction
	if target.has_method("get_facing_direction"):
		var facing := target.get_facing_direction()
		target_pos.x += look_ahead_distance * facing

	# Smooth follow
	var new_pos := global_position.lerp(target_pos, follow_speed * delta)

	# Apply camera bounds
	if use_camera_bounds:
		new_pos.x = clamp(new_pos.x, min_x, max_x)
		new_pos.y = clamp(new_pos.y, min_y, max_y)

	global_position = new_pos


func set_bounds(min_x_val: float, max_x_val: float, min_y_val: float = -100, max_y_val: float = 100) -> void:
	"""Set camera bounds for current level"""
	min_x = min_x_val
	max_x = max_x_val
	min_y = min_y_val
	max_y = max_y_val
	use_camera_bounds = true


func focus_on_position(pos: Vector2, instant: bool = false) -> void:
	"""Focus camera on specific position (for cutscenes)"""
	if instant:
		global_position = pos
	else:
		var tween := create_tween()
		tween.tween_property(self, "global_position", pos, 1.0).set_trans(Tween.TRANS_CUBIC)
