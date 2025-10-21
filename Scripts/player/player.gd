extends CharacterBody2D

var bullet_path = preload("res://Scenes/spells/fireball.tscn")

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var animated_attack = $AnimatedAttack
@onready var fireball_spawn = $FireballSpawn

var attacking = false
var justFired =false

func _physics_process(delta: float) -> void:
	# Get input direction before attack check
	
	if Globals.gameState == Globals.GAMESTATE.READY:

		var direction := Input.get_axis("move_left", "move_right")
		
		if Input.is_action_just_pressed("fire"):
			fire()
			print(Globals.playerName)
		# Handle attack (only when not moving and on floor)
		if Input.is_action_just_pressed("cast_spell") and is_on_floor():
			await get_tree().create_timer(0.1).timeout
			Globals.gameState = Globals.GAMESTATE.SETUP
		# Disable movement while attacking
	
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
		if direction > 0:
			animated_sprite.flip_h = false
			animated_attack.flip_h = false
			fireball_spawn.position.x = abs(fireball_spawn.position.x)
		elif direction < 0:
			animated_sprite.flip_h = true
			animated_attack.flip_h = true
			fireball_spawn.position.x = -abs(fireball_spawn.position.x) # flip fireball spawn location

		# Animation control (only when not attacking)
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
		
	elif Globals.gameState == Globals.GAMESTATE.SETUP:
		justFired=false
		start_attack()
	elif Globals.gameState == Globals.GAMESTATE.FIRE:
		release_attack()
		await get_tree().create_timer(0.4).timeout
		stop_attack()
		if not justFired:
			justFired = true
			fire()
		Globals.gameState = Globals.GAMESTATE.READY

func start_attack():
	animated_sprite.hide()
	animated_attack.show()
	animated_attack.play("charge", true)

func stop_attack():
	animated_attack.stop()
	animated_attack.hide()
	animated_sprite.show()

func release_attack():
	animated_sprite.hide()
	animated_attack.show()
	animated_attack.play("release")
	
func fire():
	var bullet = bullet_path.instantiate()
	bullet.position = fireball_spawn.global_position
	
	var angle = Globals.rotation

	# Flip angle if player is facing left
	if animated_sprite.flip_h:
		angle = 180 - angle
	# Normalize angle to [0, 360)
	angle = fposmod(angle, 360)

	bullet.angle_deg = angle
	print("Final angle:", bullet.angle_deg)
  
		
	bullet.speed = Globals.speed
	bullet.gravity = 100
	get_parent().add_child(bullet)
