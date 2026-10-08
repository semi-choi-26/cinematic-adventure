extends Node

"""
GameManager - 게임 전역 상태 관리 (Autoload)
싱글톤 패턴으로 어디서든 접근 가능
"""

## 시그널
signal npc_selected(npc_name: String)
signal item_collected(item_name: String, count: int)
signal quest_completed(quest_name: String)
signal game_state_changed(state_name: String, value)

## 게임 상태
var selected_npc: String = ""  # 선택한 NPC 이름
var can_select_npc: bool = true  # NPC 선택 가능 여부

## 인벤토리
var items: Dictionary = {}  # {item_name: count}
var quest_items: Array[String] = []  # 퀘스트 아이템

## 퀘스트/플래그
var flags: Dictionary = {}  # {flag_name: bool}
var quest_progress: Dictionary = {}  # {quest_name: progress}

## 게임 스탯
var coins: int = 0
var health: int = 100
var max_health: int = 100


func _ready() -> void:
	print("GameManager initialized")


## NPC 선택 시스템
func select_npc(npc_name: String) -> bool:
	"""NPC 선택 (한 번만 가능)"""
	if not can_select_npc:
		print("이미 NPC를 선택했습니다: ", selected_npc)
		return false

	selected_npc = npc_name
	can_select_npc = false
	npc_selected.emit(npc_name)

	print("NPC 선택됨: ", npc_name)
	return true


func is_npc_selected() -> bool:
	"""NPC가 선택되었는지"""
	return selected_npc != ""


func get_selected_npc() -> String:
	"""선택된 NPC 이름"""
	return selected_npc


func can_select_new_npc() -> bool:
	"""새 NPC를 선택할 수 있는지"""
	return can_select_npc


## 아이템 관리
func add_item(item_name: String, count: int = 1) -> void:
	"""아이템 추가"""
	if items.has(item_name):
		items[item_name] += count
	else:
		items[item_name] = count

	item_collected.emit(item_name, items[item_name])
	print("아이템 획득: ", item_name, " x", count, " (총: ", items[item_name], ")")


func remove_item(item_name: String, count: int = 1) -> bool:
	"""아이템 제거"""
	if not items.has(item_name):
		return false

	items[item_name] -= count
	if items[item_name] <= 0:
		items.erase(item_name)

	print("아이템 사용: ", item_name, " x", count)
	return true


func has_item(item_name: String, count: int = 1) -> bool:
	"""아이템 보유 여부"""
	return items.has(item_name) and items[item_name] >= count


func get_item_count(item_name: String) -> int:
	"""아이템 개수"""
	return items.get(item_name, 0)


## 퀘스트 아이템
func add_quest_item(item_name: String) -> void:
	"""퀘스트 아이템 추가"""
	if not quest_items.has(item_name):
		quest_items.append(item_name)
		print("퀘스트 아이템 획득: ", item_name)


func has_quest_item(item_name: String) -> bool:
	"""퀘스트 아이템 보유 여부"""
	return quest_items.has(item_name)


func get_quest_items() -> Array[String]:
	"""모든 퀘스트 아이템"""
	return quest_items


## 플래그 시스템
func set_flag(flag_name: String, value: bool = true) -> void:
	"""플래그 설정"""
	flags[flag_name] = value
	game_state_changed.emit(flag_name, value)
	print("플래그 설정: ", flag_name, " = ", value)


func get_flag(flag_name: String, default: bool = false) -> bool:
	"""플래그 값"""
	return flags.get(flag_name, default)


func has_flag(flag_name: String) -> bool:
	"""플래그 존재 여부"""
	return flags.has(flag_name)


## 퀘스트 시스템
func start_quest(quest_name: String) -> void:
	"""퀘스트 시작"""
	quest_progress[quest_name] = 0
	print("퀘스트 시작: ", quest_name)


func update_quest(quest_name: String, progress: int) -> void:
	"""퀘스트 진행도 업데이트"""
	if quest_progress.has(quest_name):
		quest_progress[quest_name] = progress
		print("퀘스트 진행: ", quest_name, " (", progress, ")")


func complete_quest(quest_name: String) -> void:
	"""퀘스트 완료"""
	quest_progress.erase(quest_name)
	set_flag(quest_name + "_completed", true)
	quest_completed.emit(quest_name)
	print("퀘스트 완료: ", quest_name)


func is_quest_completed(quest_name: String) -> bool:
	"""퀘스트 완료 여부"""
	return get_flag(quest_name + "_completed")


## 코인/체력
func add_coins(amount: int) -> void:
	"""코인 추가"""
	coins += amount
	print("코인 +", amount, " (총: ", coins, ")")


func spend_coins(amount: int) -> bool:
	"""코인 사용"""
	if coins >= amount:
		coins -= amount
		print("코인 -", amount, " (남은: ", coins, ")")
		return true
	return false


func heal(amount: int) -> void:
	"""체력 회복"""
	health = min(health + amount, max_health)
	print("체력 회복 +", amount, " (현재: ", health, "/", max_health, ")")


func damage(amount: int) -> void:
	"""데미지"""
	health = max(health - amount, 0)
	print("데미지 -", amount, " (현재: ", health, "/", max_health, ")")


## 디버그
func print_state() -> void:
	"""현재 상태 출력"""
	print("\n=== Game State ===")
	print("Selected NPC: ", selected_npc if selected_npc != "" else "None")
	print("Coins: ", coins)
	print("Health: ", health, "/", max_health)
	print("Items: ", items)
	print("Quest Items: ", quest_items)
	print("Flags: ", flags)
	print("Quests: ", quest_progress)
	print("==================\n")


## 리셋 (디버그용)
func reset_game() -> void:
	"""게임 상태 초기화"""
	selected_npc = ""
	can_select_npc = true
	items.clear()
	quest_items.clear()
	flags.clear()
	quest_progress.clear()
	coins = 0
	health = max_health
	print("Game state reset!")
