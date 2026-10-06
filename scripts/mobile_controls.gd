extends CanvasLayer
class_name MobileControls

"""
모바일 터치 컨트롤 - 최적화 버전
로그 최소화
"""

var is_touching: bool = false
var touch_pos: Vector2 = Vector2.ZERO
var last_direction: String = ""


func _ready() -> void:
	print("Mobile controls ready")


func _input(event: InputEvent) -> void:
	# 터치 시작
	if event is InputEventScreenTouch:
		if event.pressed:
			is_touching = true
			touch_pos = event.position
			handle_touch(event.position)
		else:
			is_touching = false
			clear_all_inputs()
			queue_redraw()

	# 터치 드래그
	elif event is InputEventScreenDrag:
		touch_pos = event.position
		handle_touch(event.position)

	# 마우스 (PC 테스트용)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_touching = true
				touch_pos = event.position
				handle_touch(event.position)
			else:
				is_touching = false
				clear_all_inputs()
				queue_redraw()

	elif event is InputEventMouseMotion:
		if is_touching:
			touch_pos = event.position
			handle_touch(event.position)


func handle_touch(pos: Vector2) -> void:
	"""터치 위치에 따라 입력 처리"""
	var screen_size = get_viewport().get_visible_rect().size
	var center = screen_size / 2
	var diff = pos - center

	# 모든 입력 초기화
	clear_all_inputs()

	var new_direction = ""

	# 좌우 (100px 이상 차이)
	if abs(diff.x) > 100:
		if diff.x < 0:
			Input.action_press("move_left")
			new_direction += "LEFT "
		else:
			Input.action_press("move_right")
			new_direction += "RIGHT "

	# 상하 (100px 이상 차이)
	if abs(diff.y) > 100:
		if diff.y < 0:
			Input.action_press("move_up")
			new_direction += "UP "
		else:
			Input.action_press("move_down")
			new_direction += "DOWN "

	# 방향이 바뀔 때만 로그 출력
	if new_direction != last_direction and new_direction != "":
		print("Moving: ", new_direction)
		last_direction = new_direction

	# 디버그 표시 업데이트
	queue_redraw()


func clear_all_inputs() -> void:
	"""모든 입력 해제"""
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("move_up")
	Input.action_release("move_down")
	last_direction = ""


func _draw() -> void:
	"""디버그: 터치 위치 표시"""
	if is_touching:
		var screen_size = get_viewport().get_visible_rect().size
		var center = screen_size / 2

		# 화면 중앙 (녹색 원)
		draw_circle(center, 20, Color(0, 1, 0, 0.8))

		# 터치 위치 (노란색 원)
		draw_circle(touch_pos, 40, Color(1, 1, 0, 0.8))

		# 중앙에서 터치까지 선 (빨간색)
		draw_line(center, touch_pos, Color(1, 0, 0, 0.8), 5.0)
