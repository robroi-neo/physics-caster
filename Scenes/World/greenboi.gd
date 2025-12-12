extends CharacterBody2D

@onready var animation = $AnimatedSprite2D

enum NpcState { IDLE, IDLE_ACTIVE, QUEST, QUEST_ACTIVE}
var current_state: NpcState = NpcState.IDLE

var has_quest: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_animation()

func handle_animation():
	match current_state:
		NpcState.IDLE: animation.play("idle")
		NpcState.IDLE_ACTIVE: animation.play("idle_active")
		NpcState.QUEST: animation.play("quest")
		NpcState.QUEST_ACTIVE: animation.play("quest_active")

func interact(name):
	print(has_quest)
	print("Hello Player!", name)
	has_quest = !has_quest

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player Entered")
		if has_quest:
			current_state = NpcState.QUEST_ACTIVE
		else:
			current_state = NpcState.IDLE_ACTIVE
			
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player Exit")
		if has_quest:
			current_state = NpcState.QUEST
		else:
			current_state = NpcState.IDLE
