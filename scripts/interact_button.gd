extends CanvasLayer
class_name InteractButton

"""
모바일 상호작용 버튼
NPC 근처에 있을 때만 표시
"""

@onready var button: Button = $Button

var is_near_interactable: bool = false


func _ready() -> void:
	# 처음에는 숨김
	button.visible = false

	# 버튼 클릭 시 interact 액션 발생
	button.pressed.connect(_on_button_pressed)

	print("Interact button ready")


func _process(_delta: float) -> void:
	# 상호작용 가능한 오브젝트 근처인지 확인
	check_nearby_interactables()


func check_nearby_interactables() -> void:
	"""상호작용 가능한 오브젝트가 근처에 있는지 확인"""
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		button.visible = false
		return

	var found_interactable = false

	# 모든 Interactable 찾기
	for node in get_tree().get_nodes_in_group("npc"):
		if node is Interactable:
			var interactable = node as Interactable
			# 플레이어가 근처에 있는지 확인
			if interactable.player_nearby:
				found_interactable = true
				break

	# 버튼 표시/숨김
	button.visible = found_interactable


func _on_button_pressed() -> void:
	"""버튼 클릭 시 E 키 입력 시뮬레이션"""
	var event = InputEventAction.new()
	event.action = "interact"
	event.pressed = true
	Input.parse_input_event(event)

	# 즉시 해제
	await get_tree().process_frame
	event.pressed = false
	Input.parse_input_event(event)

	print("Interact button pressed!")


func show_button() -> void:
	"""버튼 표시"""
	button.visible = true


func hide_button() -> void:
	"""버튼 숨김"""
	button.visible = false
