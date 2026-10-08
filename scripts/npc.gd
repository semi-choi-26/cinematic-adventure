extends Interactable
class_name NPC

"""
NPC (Non-Player Character)
대화 가능한 캐릭터 + 미니게임
"""

## NPC 정보
@export var npc_name: String = "NPC"
@export_multiline var dialogue_text: String = "Hello, traveler!"
@export var dialogue_file: String = ""  # JSON 파일 경로 (옵션)

## 미니게임 설정
@export var has_minigame: bool = false
@export var minigame_reward: String = ""  # 보상 아이템 이름
@export_multiline var already_selected_message: String = "당신은 이미 다른 사람과 함께하기로 했군요."
@export_multiline var after_game_message: String = "재미있었습니다!"

## 대화 상태
var dialogue_index: int = 0
var dialogue_lines: Array[String] = []
var game_completed: bool = false

## 노드
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null

## 참조
var dialogue_box: DialogueBox = null
var minigame: MiniGameRPS = null


func _ready() -> void:
	super._ready()

	interaction_prompt = "E to talk"

	# 대화 라인 파싱
	if dialogue_file != "":
		load_dialogue_from_file()
	else:
		dialogue_lines = dialogue_text.split("\n")

	# DialogueBox와 MiniGame 찾기
	await get_tree().process_frame
	var main = get_tree().current_scene
	if main:
		dialogue_box = main.get_node_or_null("DialogueBox")
		minigame = main.get_node_or_null("MiniGameRPS")

	# 미니게임 시그널 연결
	if minigame:
		minigame.game_finished.connect(_on_minigame_finished)

	# 기본 애니메이션
	if sprite and sprite.sprite_frames:
		if sprite.sprite_frames.has_animation("idle"):
			sprite.play("idle")


func _on_interact() -> void:
	"""대화/미니게임 시작"""
	# 다른 NPC가 이미 선택되었는지 체크
	if has_minigame and GameManager.is_npc_selected():
		if GameManager.get_selected_npc() != npc_name:
			# 다른 NPC가 선택됨
			show_rejection_message()
			return

	# 이미 게임을 완료했는지 체크
	if game_completed:
		show_after_game_message()
		return

	# 일반 대화 시작
	start_dialogue()


func start_dialogue() -> void:
	"""대화 시작"""
	dialogue_index = 0
	show_dialogue()


func show_dialogue() -> void:
	"""현재 대화 라인 표시"""
	if dialogue_index < dialogue_lines.size():
		var line = dialogue_lines[dialogue_index]
		print("[", npc_name, "] ", line)

		# DialogueBox에 표시
		if dialogue_box:
			dialogue_box.show_dialogue(npc_name, line, self)

		dialogue_index += 1
	else:
		# 대화 끝 - 미니게임 있으면 시작
		if has_minigame and not game_completed:
			end_dialogue()
			start_minigame()
		else:
			end_dialogue()


func next_dialogue() -> void:
	"""다음 대화로"""
	show_dialogue()


func end_dialogue() -> void:
	"""대화 종료"""
	dialogue_index = 0

	# DialogueBox 닫기
	if dialogue_box:
		dialogue_box.hide_dialogue()


func start_minigame() -> void:
	"""미니게임 시작"""
	if not minigame:
		print("MiniGame not found!")
		return

	# NPC 선택 (한 번만)
	if GameManager.select_npc(npc_name):
		print("Starting minigame with: ", npc_name)
		minigame.start_game(npc_name, minigame_reward)
	else:
		print("Cannot start minigame - another NPC already selected")


func _on_minigame_finished(player_won: bool) -> void:
	"""미니게임 완료"""
	game_completed = true

	if player_won:
		print(npc_name, ": 당신이 이겼군요!")
		# 보상은 미니게임에서 이미 지급됨
	else:
		print(npc_name, ": 제가 이겼네요!")


func show_rejection_message() -> void:
	"""거절 메시지 (다른 NPC 이미 선택됨)"""
	print("[", npc_name, "] ", already_selected_message)

	if dialogue_box:
		dialogue_box.show_dialogue(npc_name, already_selected_message, self)
		# 2초 후 자동 닫기
		await get_tree().create_timer(2.0).timeout
		if dialogue_box:
			dialogue_box.hide_dialogue()


func show_after_game_message() -> void:
	"""게임 완료 후 메시지"""
	print("[", npc_name, "] ", after_game_message)

	if dialogue_box:
		dialogue_box.show_dialogue(npc_name, after_game_message, self)
		# 2초 후 자동 닫기
		await get_tree().create_timer(2.0).timeout
		if dialogue_box:
			dialogue_box.hide_dialogue()


func load_dialogue_from_file() -> void:
	"""JSON 파일에서 대화 로드"""
	if not FileAccess.file_exists(dialogue_file):
		print("Dialogue file not found: ", dialogue_file)
		return

	var file = FileAccess.open(dialogue_file, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(json_string)

		if error == OK:
			var data = json.data
			if data.has("name"):
				npc_name = data["name"]
			if data.has("dialogue"):
				dialogue_lines = data["dialogue"]
		else:
			print("JSON parse error: ", json.get_error_message())

		file.close()


func set_dialogue(lines: Array[String]) -> void:
	"""대화 라인 설정"""
	dialogue_lines = lines
	dialogue_index = 0
