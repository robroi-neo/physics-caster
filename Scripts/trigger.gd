extends AnimatableBody2D

@onready var fire_animation = $FireAnimation

@export var is_triggered: bool = false
signal activated(action: String)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire_animation.hide()
	fire_animation.stop()
	pass # Replace with function body.

func _on_hit_area_body_entered(body: Node2D) -> void:
	# add script to detect fireball
	if body.is_in_group("fire_ball"):
		if !is_triggered:
			is_triggered = true
			
			# play fire animation
			fire_animation.show()
			fire_animation.play()
			
			# emit signal
			emit_signal("activated")
	
