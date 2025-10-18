extends CharacterBody2D

var bullet_path = preload("res://Scenes/fireball.tscn")

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var animated_attack = $AnimatedAttack

var attacking = false

func _physics_process(delta: float) -> void:
	# Get input direction before attack check
	var direction := Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("fire"):
		fire()

	# Handle attack (only when not moving and on floor)
	if Input.is_action_just_pressed("cast_spell") and is_on_floor() and direction == 0:
		await get_tree().create_timer(0.1).timeout
		attacking = !attacking

	if attacking:
		start_attack()
	else:
		stop_attack()

	# Disable movement while attacking
	if attacking:
		velocity.x = 0
	else:
		# Apply gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Movement logic
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip sprites
	if direction > 0 and not attacking:
		animated_sprite.flip_h = false
		animated_attack.flip_h = false
	elif direction < 0 and not attacking:
		animated_sprite.flip_h = true
		animated_attack.flip_h = true

	# Animation control (only when not attacking)
	if not attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")	
		else:
			if velocity.y < 0:
				animated_sprite.play("rising")
			elif velocity.y > 0:
				animated_sprite.play("falling")

	move_and_slide()

func start_attack():
	animated_sprite.hide()
	animated_attack.show()
	animated_attack.play("charge", true)

func stop_attack():
	animated_attack.stop()
	animated_attack.hide()
	animated_sprite.show()

func fire():
	var bullet = bullet_path.instantiate()
	bullet.position = $Node2D.global_position
	bullet.gravity = 0
	bullet.angle_deg = 180.0     # set angle manually or by player aim
	bullet.speed = 10.0
	get_parent().add_child(bullet)
