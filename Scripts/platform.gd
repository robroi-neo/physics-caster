extends StaticBody2D

@export var target_y: float
@export var float_speed: float = 100.0
@export_enum("move", "fall", "vanish", "raise") var action = "move"
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func activate(action):
	print("target received action: ", action)
	match action:
		"move_up":
			move_platform()
		"fall":
			pass
		"vanish":
			pass
		"raise":
			pass

func move_platform():
	print(name, " is moving")
	var tween = create_tween()
	tween.tween_property(self, "position:y", target_y, 1.5)  # 1.5 seconds
	
