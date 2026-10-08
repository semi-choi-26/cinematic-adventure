extends Interactable
class_name Item

"""
수집 가능한 아이템
코인, 체력 포션, 열쇠 등
"""

## 아이템 타입
enum ItemType {
	COIN,
	HEALTH_POTION,
	KEY,
	QUEST_ITEM,
	OTHER
}

## 설정
@export var item_type: ItemType = ItemType.COIN
@export var item_name: String = "Item"
@export var item_value: int = 1
@export var auto_collect: bool = true  # 플레이어가 닿으면 자동 수집

## 노드
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var collision_shape: CollisionShape2D = $CollisionShape2D if has_node("CollisionShape2D") else null


func _ready() -> void:
	super._ready()

	# 자동 수집 모드면 상호작용 프롬프트 불필요
	if auto_collect:
		interaction_prompt = ""


func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)

	# 자동 수집
	if auto_collect and body is Player:
		collect(body)


func _on_interact() -> void:
	"""E 키로 수집"""
	if current_player and not auto_collect:
		collect(current_player)


func collect(player: Player) -> void:
	"""아이템 수집"""
	print("Collected: ", item_name, " x", item_value)

	# 수집 효과
	play_collect_animation()

	# TODO: 인벤토리에 추가
	# GameManager.add_item(item_type, item_value)

	# 아이템 제거
	queue_free()


func play_collect_animation() -> void:
	"""수집 애니메이션 (위로 떠오르며 사라짐)"""
	if sprite:
		# Tween으로 애니메이션
		var tween = create_tween()
		tween.set_parallel(true)

		# 위로 이동
		tween.tween_property(sprite, "position", sprite.position + Vector2(0, -50), 0.5)

		# 페이드 아웃
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5)

		# 애니메이션 끝나면 제거
		tween.finished.connect(func(): queue_free())
	else:
		# 스프라이트 없으면 바로 제거
		queue_free()
