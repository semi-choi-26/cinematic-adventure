extends Area2D
class_name Interactable

"""
상호작용 가능한 오브젝트의 베이스 클래스
NPC, 아이템, 문 등 모든 상호작용 가능한 것들의 부모
"""

## 상호작용 시그널
signal interacted(player: Player)
signal player_entered(player: Player)
signal player_exited(player: Player)

## 설정
@export var interaction_prompt: String = "E to interact"
@export var can_interact: bool = true

## 상태
var player_nearby: bool = false
var current_player: Player = null


func _ready() -> void:
	# Area2D 시그널 연결
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# 기본 충돌 레이어 설정
	collision_layer = 0
	collision_mask = 1  # Player 레이어


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_nearby = true
		current_player = body
		player_entered.emit(body)
		show_prompt()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_nearby = false
		current_player = null
		player_exited.emit(body)
		hide_prompt()


func _input(event: InputEvent) -> void:
	# E 키로 상호작용
	if event.is_action_pressed("interact") and player_nearby and can_interact:
		interact()


func interact() -> void:
	"""상호작용 실행 (자식 클래스에서 오버라이드)"""
	if not can_interact:
		return

	print("Interacting with: ", name)
	interacted.emit(current_player)
	_on_interact()


func _on_interact() -> void:
	"""상호작용 로직 (자식 클래스에서 구현)"""
	pass


func show_prompt() -> void:
	"""상호작용 프롬프트 표시"""
	# TODO: UI 구현 후 프롬프트 표시
	print("Show prompt: ", interaction_prompt)


func hide_prompt() -> void:
	"""상호작용 프롬프트 숨김"""
	# TODO: UI 구현 후 프롬프트 숨김
	print("Hide prompt")


func enable_interaction() -> void:
	"""상호작용 활성화"""
	can_interact = true


func disable_interaction() -> void:
	"""상호작용 비활성화"""
	can_interact = false
