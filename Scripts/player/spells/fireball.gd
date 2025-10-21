extends CharacterBody2D

@export var speed: float = 10.0      # initial speed
@export var angle_deg: float = 90.0   # launch angle
@export var gravity: float = 1600.0    # gravity strength

var projectile_velocity: Vector2
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	var angle_rad = deg_to_rad(angle_deg)
	projectile_velocity = Vector2(speed * cos(angle_rad), -speed * sin(angle_rad))
	

func _physics_process(delta):
	animated_sprite.play("effect_1")
	projectile_velocity.y += gravity * delta
	position += projectile_velocity * delta
	rotation = projectile_velocity.angle()
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group('ground') :
			print("🔥 Fireball hit the ground!")
			Globals.gameState = Globals.GAMESTATE.READY
		else:
			print("🔥 Fireball hit something else:", collider)

	# remove when far below the screen
	if position.y > 400:
		Globals.gameState = Globals.GAMESTATE.READY
