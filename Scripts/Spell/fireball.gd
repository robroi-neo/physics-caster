extends RigidBody2D

@export var speed: float = 500.0
@export var angle_deg: float = 0.0
@export var gravity: float = 1600.0

@onready var animated_sprite = $AnimatedSprite2D

# You’ll set this from the player script
var facing_left: bool = false

func _ready():
	# speed multiplier cuz gamay kaayo normally
	speed = speed * 10
	
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
	if body.is_in_group("ground"):
		queue_free()
	pass # Replace with function body.
