extends CanvasLayer
class_name DialogueBox

"""
대화 UI
NPC와의 대화를 표시
"""

## 노드
@onready var panel: Panel = $Panel
@onready var name_label: Label = $Panel/MarginContainer/VBoxContainer/NameLabel
@onready var dialogue_label: Label = $Panel/MarginContainer/VBoxContainer/DialogueLabel
@onready var continue_label: Label = $Panel/MarginContainer/VBoxContainer/ContinueLabel

## 타이핑 효과
@export var typing_speed: float = 0.05  # 글자당 시간 (초)
var is_typing: bool = false
var current_text: String = ""
var current_npc: NPC = null

## 시그널
signal dialogue_finished()
signal next_requested()


func _ready() -> void:
	# 처음에는 숨김
	hide_dialogue()


func _input(event: InputEvent) -> void:
	if not visible:
		return

	# E 키로 다음 대화
	if event.is_action_pressed("interact"):
		if is_typing:
			# 타이핑 중이면 즉시 완료
			complete_typing()
		else:
			# 다음 대화로
			next_requested.emit()
			if current_npc:
				current_npc.next_dialogue()


func show_dialogue(npc_name: String, text: String, npc: NPC = null) -> void:
	"""대화 표시"""
	visible = true
	current_npc = npc

	name_label.text = npc_name
	dialogue_label.text = ""
	current_text = text

	# 타이핑 효과 시작
	start_typing()


func hide_dialogue() -> void:
	"""대화 숨김"""
	visible = false
	current_npc = null
	is_typing = false
	dialogue_finished.emit()


func start_typing() -> void:
	"""타이핑 효과 시작"""
	is_typing = true
	dialogue_label.text = ""
	continue_label.visible = false

	# 한 글자씩 표시
	for i in range(current_text.length()):
		if not is_typing:
			break

		dialogue_label.text += current_text[i]
		await get_tree().create_timer(typing_speed).timeout

	# 타이핑 완료
	complete_typing()


func complete_typing() -> void:
	"""타이핑 즉시 완료"""
	is_typing = false
	dialogue_label.text = current_text
	continue_label.visible = true
