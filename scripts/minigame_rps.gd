extends CanvasLayer
class_name MiniGameRPS

"""
가위바위보 미니게임
Rock-Paper-Scissors
"""

enum Choice { ROCK, PAPER, SCISSORS }
enum Result { WIN, LOSE, DRAW }

## 시그널
signal game_finished(player_won: bool)

## 노드
@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var round_label: Label = $Panel/MarginContainer/VBoxContainer/RoundLabel
@ontml:parameter>
@onready var result_label: Label = $Panel/MarginContainer/VBoxContainer/ResultLabel
@onready var button_container: HBoxContainer = $Panel/MarginContainer/VBoxContainer/ButtonContainer
@onready var rock_button: Button = $Panel/MarginContainer/VBoxContainer/ButtonContainer/RockButton
@onready var paper_button: Button = $Panel/MarginContainer/VBoxContainer/ButtonContainer/PaperButton
@onready var scissors_button: Button = $Panel/MarginContainer/VBoxContainer/ButtonContainer/ScissorsButton

## 게임 상태
var current_round: int = 0
var max_rounds: int = 3
var player_wins: int = 0
var npc_wins: int = 0
var npc_name: String = "NPC"
var reward_item: String = ""


func _ready() -> void:
	# 처음에는 숨김
	hide_game()

	# 버튼 연결
	rock_button.pressed.connect(func(): player_choice(Choice.ROCK))
	paper_button.pressed.connect(func(): player_choice(Choice.PAPER))
	scissors_button.pressed.connect(func(): player_choice(Choice.SCISSORS))


func start_game(opponent_name: String, item_reward: String = "") -> void:
	"""게임 시작"""
	npc_name = opponent_name
	reward_item = item_reward
	current_round = 0
	player_wins = 0
	npc_wins = 0

	visible = true
	title_label.text = npc_name + "와의 가위바위보!"
	update_ui()
	enable_buttons()


func hide_game() -> void:
	"""게임 숨김"""
	visible = false


func player_choice(choice: Choice) -> void:
	"""플레이어 선택"""
	disable_buttons()
	current_round += 1

	# NPC 선택 (랜덤)
	var npc_choice = randi() % 3 as Choice

	# 결과 판정
	var result = judge(choice, npc_choice)

	# 결과 표시
	show_result(choice, npc_choice, result)

	# 점수 업데이트
	if result == Result.WIN:
		player_wins += 1
	elif result == Result.LOSE:
		npc_wins += 1

	# 다음 라운드 또는 게임 종료
	await get_tree().create_timer(2.0).timeout

	if current_round >= max_rounds:
		end_game()
	else:
		update_ui()
		enable_buttons()


func judge(player: Choice, npc: Choice) -> Result:
	"""승부 판정"""
	if player == npc:
		return Result.DRAW
	elif (player == Choice.ROCK and npc == Choice.SCISSORS) or \
		 (player == Choice.PAPER and npc == Choice.ROCK) or \
		 (player == Choice.SCISSORS and npc == Choice.PAPER):
		return Result.WIN
	else:
		return Result.LOSE


func show_result(player: Choice, npc: Choice, result: Result) -> void:
	"""결과 표시"""
	var player_text = choice_to_string(player)
	var npc_text = choice_to_string(npc)

	var result_text = ""
	match result:
		Result.WIN:
			result_text = "승리!"
		Result.LOSE:
			result_text = "패배..."
		Result.DRAW:
			result_text = "무승부"

	result_label.text = "당신: " + player_text + " vs " + npc_name + ": " + npc_text + "\n" + result_text


func choice_to_string(choice: Choice) -> String:
	"""선택을 문자열로"""
	match choice:
		Choice.ROCK:
			return "바위"
		Choice.PAPER:
			return "보"
		Choice.SCISSORS:
			return "가위"
		_:
			return ""


func update_ui() -> void:
	"""UI 업데이트"""
	round_label.text = "라운드: " + str(current_round + 1) + "/" + str(max_rounds)
	result_label.text = "점수 - 당신: " + str(player_wins) + " | " + npc_name + ": " + str(npc_wins)


func enable_buttons() -> void:
	"""버튼 활성화"""
	rock_button.disabled = false
	paper_button.disabled = false
	scissors_button.disabled = false


func disable_buttons() -> void:
	"""버튼 비활성화"""
	rock_button.disabled = true
	paper_button.disabled = true
	scissors_button.disabled = true


func end_game() -> void:
	"""게임 종료"""
	var player_won = player_wins > npc_wins

	if player_won:
		result_label.text = "🎉 승리! 🎉\n" + str(player_wins) + " : " + str(npc_wins)

		# 보상 지급
		if reward_item != "":
			GameManager.add_quest_item(reward_item)
			result_label.text += "\n\n'" + reward_item + "' 획득!"
	else:
		result_label.text = "😢 패배... 😢\n" + str(player_wins) + " : " + str(npc_wins)

	# 2초 후 닫기
	await get_tree().create_timer(2.0).timeout
	game_finished.emit(player_won)
	hide_game()
