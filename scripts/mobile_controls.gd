extends CanvasLayer
class_name MobileControls

"""
모바일 전체 화면 터치 컨트롤
플레이어 기준으로 상대적 방향 계산:
- 플레이어 왼쪽 터치 = 왼쪽 이동
- 플레이어 오른쪽 터치 = 오른쪽 이동
- 플레이어 위쪽 터치 = 위 이동
- 플레이어 아래쪽 터치 = 아래 이동
"""

var player: Node2D = null
var is_touching: bool = false
var touch_position: Vector2 = Vector2.ZERO

# 가상 입력 상태
var virtual_left: bool = false
var virtual_right: bool = false
var virtual_up: bool = false
var virtual_down: bool = false


func _ready() -> void:
	# 플레이어 찾기
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	print("Mobile touch controls ready")


func _input(event: InputEvent) -> void:
	if not player:
		return

	# 터치 또는 마우스 입력 처리
	if event is InputEventScreenTouch:
		if event.pressed:
			is_touching = true
			touch_position = event.position
			update_virtual_input()
		else:
			is_touching = false
			clear_virtual_input()

	elif event is InputEventScreenDrag:
		if is_touching:
			touch_position = event.position
			update_virtual_input()

	# 마우스 입력 (PC 테스트용)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_touching = true
				touch_position = event.position
				update_virtual_input()
			else:
				is_touching = false
				clear_virtual_input()

	elif event is InputEventMouseMotion:
		if is_touching:
			touch_position = event.position
			update_virtual_input()


func update_virtual_input() -> void:
	"""터치 위치에 따라 가상 입력 업데이트"""
	if not player:
		return

	# 플레이어의 화면 좌표
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return

	var player_screen_pos = camera.get_screen_center_position() + (player.global_position - camera.global_position)

	# 터치 위치와 플레이어 위치 비교
	var diff = touch_position - player_screen_pos

	# 가상 입력 초기화
	clear_virtual_input()

	# 좌우 방향 (수평 차이가 큰 경우)
	if abs(diff.x) > 50:  # 최소 거리 50px
		if diff.x < 0:
			virtual_left = true
			Input.action_press("move_left")
		else:
			virtual_right = true
			Input.action_press("move_right")

	# 상하 방향 (수직 차이가 큰 경우)
	if abs(diff.y) > 50:  # 최소 거리 50px
		if diff.y < 0:
			virtual_up = true
			Input.action_press("move_up")
		else:
			virtual_down = true
			Input.action_press("move_down")


func clear_virtual_input() -> void:
	"""가상 입력 해제"""
	if virtual_left:
		Input.action_release("move_left")
		virtual_left = false
	if virtual_right:
		Input.action_release("move_right")
		virtual_right = false
	if virtual_up:
		Input.action_release("move_up")
		virtual_up = false
	if virtual_down:
		Input.action_release("move_down")
		virtual_down = false


func _process(_delta: float) -> void:
	# 디버그: 터치 위치 표시 (선택사항)
	queue_redraw()


func _draw() -> void:
	"""디버그: 터치 위치 시각화"""
	if is_touching:
		# 터치 위치에 원 그리기
		draw_circle(touch_position, 20, Color(1, 1, 0, 0.5))
