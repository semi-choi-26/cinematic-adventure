extends ParallaxBackground
class_name ParallaxController

## Parallax Background Controller
## 카메라 이동에 따라 각 레이어가 다른 속도로 스크롤

# 카메라 참조
var camera: Camera2D = null

# 이전 카메라 위치
var previous_camera_pos := Vector2.ZERO


func _ready() -> void:
	# 플레이어의 카메라 찾기
	await get_tree().process_frame
	var player = get_tree().get_first_node_in_group("player")

	if player and player.has_node("Camera2D"):
		camera = player.get_node("Camera2D")
		previous_camera_pos = camera.global_position
		print("ParallaxController: Camera found")
	else:
		push_warning("ParallaxController: Camera not found")


func _process(_delta: float) -> void:
	if not camera:
		return

	# 카메라 이동량 계산
	var camera_pos = camera.global_position
	var camera_movement = camera_pos - previous_camera_pos

	# 패럴랙스 오프셋 업데이트
	scroll_offset += camera_movement

	# 이전 위치 저장
	previous_camera_pos = camera_pos
