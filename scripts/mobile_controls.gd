extends CanvasLayer
class_name MobileControls

"""
모바일 전체 화면 터치 컨트롤 (간단한 버전)
화면 중앙 기준으로 4방향 터치
"""

var touch_area: Control
var is_touching: bool = false
var touch_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	# 전체 화면 터치 영역 생성
	touch_area = Control.new()
	touch_area.set_anchors_preset(Control.PRESET_FULL_RECT)
	touch_area.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(touch_area)

	# 터치 이벤트 연결
	touch_area.gui_input.connect(_on_touch_input)

	print("Mobile touch controls ready (simple version)")


func _on_touch_input(event: InputEvent) -> void:
	var screen_center = get_viewport().get_visible_rect().size / 2

	# 터치 시작
	if event is InputEventScreenTouch:
		if event.pressed:
			is_touching = true
			touch_pos = event.position
			_simulate_input(touch_pos, screen_center)
		else:
			is_touching = false
			_clear_input()

	# 터치 드래그
	elif event is InputEventScreenDrag:
		touch_pos = event.position
		_simulate_input(touch_pos, screen_center)

	# 마우스 (PC 테스트용)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_touching = true
				touch_pos = event.position
				_simulate_input(touch_pos, screen_center)
			else:
				is_touching = false
				_clear_input()

	elif event is InputEventMouseMotion:
		if is_touching and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			touch_pos = event.position
			_simulate_input(touch_pos, screen_center)


func _simulate_input(touch: Vector2, center: Vector2) -> void:
	"""터치 위치에 따라 입력 시뮬레이션"""
	var diff = touch - center

	# 좌우 (수평 거리 > 100px)
	if abs(diff.x) > 100:
		if diff.x < 0:
			_press_action("move_left")
			_release_action("move_right")
		else:
			_press_action("move_right")
			_release_action("move_left")
	else:
		_release_action("move_left")
		_release_action("move_right")

	# 상하 (수직 거리 > 100px)
	if abs(diff.y) > 100:
		if diff.y < 0:
			_press_action("move_up")
			_release_action("move_down")
		else:
			_press_action("move_down")
			_release_action("move_up")
	else:
		_release_action("move_up")
		_release_action("move_down")


func _press_action(action: String) -> void:
	"""액션 누름 시뮬레이션"""
	if not Input.is_action_pressed(action):
		var event = InputEventAction.new()
		event.action = action
		event.pressed = true
		Input.parse_input_event(event)


func _release_action(action: String) -> void:
	"""액션 해제 시뮬레이션"""
	if Input.is_action_pressed(action):
		var event = InputEventAction.new()
		event.action = action
		event.pressed = false
		Input.parse_input_event(event)


func _clear_input() -> void:
	"""모든 입력 해제"""
	_release_action("move_left")
	_release_action("move_right")
	_release_action("move_up")
	_release_action("move_down")


func _process(_delta: float) -> void:
	# 디버그: 터치 위치 표시
	if is_touching:
		queue_redraw()


func _draw() -> void:
	"""디버그: 터치 위치와 방향 표시"""
	if is_touching:
		var screen_center = get_viewport().get_visible_rect().size / 2

		# 터치 위치
		draw_circle(touch_pos, 30, Color(1, 1, 0, 0.7))

		# 중앙에서 터치까지 선
		draw_line(screen_center, touch_pos, Color(1, 0, 0, 0.5), 3.0)

		# 화면 중앙 표시
		draw_circle(screen_center, 10, Color(0, 1, 0, 0.5))
