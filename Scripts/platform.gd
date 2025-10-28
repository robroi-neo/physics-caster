extends StaticBody2D

@export var target_y: float
@export var float_speed: float = 100.0
@export_enum("move", "move_up_down", "vanish", "raise") var action = "move"
var moving = false

var previous_position: Vector2
@onready var detector = $Detector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_position = position

func _process(delta):
	# track how much the platform moved since last frame
	var move_delta = position - previous_position
	previous_position = position

	# move any players standing on the platform by the same amount
	for body in detector.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.position += move_delta

func activate(action):
	print("target received action: ", action)
	match action:
		"move_up":
			move_platform()
		"move_up_down":
			move_up_down()
		"vanish":
			pass
		"raise":
			pass

func move_platform():
	print(name, " is moving")
	var tween = create_tween()
	tween.tween_property(self, "position:y", target_y, 1.5)  # 1.5 seconds
	
func move_up_down():
	print(name, "moving up and down")
	print(target_y)
	var start_y = position.y
	var wait_time = 1.0           # seconds to stay up

	var tween = create_tween()
	tween.set_loops()  # ♾️ makes it repeat forever

	tween.tween_property(self, "position:y", target_y, 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.tween_interval(wait_time)

	tween.tween_property(self, "position:y", start_y, 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.tween_interval(wait_time)


	
