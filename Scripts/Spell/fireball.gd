extends RigidBody2D

@export var speed: float = 500.0
@export var angle_deg: float = 0.0
@export var gravity: float = 200.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var disappear_timer = $DisappearTimer

# You’ll set this from the player script
var facing_left: bool = false
var start_timer: bool = false

func _ready():
	# speed multiplier cuz gamay kaayo normally
	speed *= 5
	 
	var angle_rad = deg_to_rad(angle_deg)
	# Flip direction if facing left
	if facing_left:
		angle_rad = PI - angle_rad  # 180° flip
	
	var projectile_velocity = Vector2(speed * cos(angle_rad), -speed * sin(angle_rad))
	linear_velocity = projectile_velocity
	rotation = projectile_velocity.angle()

	animated_sprite.play("effect_1")

func _integrate_forces(state):
	var lv = linear_velocity
	lv.y += gravity * state.step
	linear_velocity = lv

	if lv.length() > 0:
		rotation = lv.angle()

	if global_position.y > 400:
		pass
		
func _on_body_entered(body: Node) -> void:
	if !start_timer && (body.is_in_group("ground") || body.is_in_group("platform")):
		disappear_timer.start()
		start_timer = true
		print("timer started")
			

func _on_disappear_timer_timeout() -> void:
	disappear_timer.stop()	
	start_timer = false
	queue_free()
	print("timer end")
	pass # Replace with function body.
