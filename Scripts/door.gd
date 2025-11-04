extends AnimatableBody2D

@onready var animatebleSprite = $AnimatableSprite
var play_time = 0
var level_complete = preload("res://Scenes/World/level_complete.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	play_time += delta
	if Input.is_action_just_pressed("enter") and animatebleSprite.animation == "open":
		var next_scene = level_complete.instantiate()
		next_scene.play_time = int(play_time)
		get_tree().root.add_child(next_scene)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = next_scene
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animatebleSprite.play("open")
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	animatebleSprite.play("close")

	pass # Replace with function body.
