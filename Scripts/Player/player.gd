extends CharacterBody2D

@export var SPEED: int = 400
@export var ACCELERATION: int = 15
@export var JUMP_VELOCITY: float = -SPEED * 1.8
@export var GRAVITY: float = SPEED * 5
@export var DOWN_GRAVITY_FACTOR: float = 1.5

@onready var movement_sprite = $MovementAnimation
@onready var attack_sprite = $AttackAnimation
@onready var fireball_spawn = $Node2D
@onready var jump_buffer_timer = $JumpBufferTimer
@onready var cayote_timer = $CayoteTimer
@onready var cast_expire_timer = $CastExpireTimer
@onready var angle_input = $"../AngleInput"
@onready var speed_input = $"../SpeedInput"


enum PlayerState { IDLE, WALK, JUMP, DOWN, CAST, RELEASE}
var current_state: PlayerState = PlayerState.IDLE

enum CastStage { STOP, START, ANGLE_INPUT, SPEED_INPUT, RELEASE}
var cast_stage: CastStage = CastStage.STOP

# angle correction from fireball
var facing_left: bool = false

# global fireball values
var fireball_angle: float 
var fireball_speed: float

func _ready():
	cast_expire_timer.timeout.connect(_on_cast_expire_timeout)
	angle_input.input_submitted.connect(_on_angle_submitted)
	speed_input.input_submitted.connect(_on_speed_submitted)


func _physics_process(delta: float) -> void:
	handle_input()
	update_movement(delta)
	update_states()
	update_attack_states()
	update_animation()
	move_and_slide() 

func handle_input() -> void:
	# dprint(current_state	
	if Input.is_action_just_pressed("attack")  and current_state not in [PlayerState.RELEASE, PlayerState.JUMP]:
		if current_state == PlayerState.CAST:
			# cancel cast
			cast_expire_timer.stop()
			
			angle_input.enable(false)
			speed_input.enable(false)
			
			cast_stage = CastStage.STOP
			current_state = PlayerState.IDLE		
			print("Cast canceled")	
			return
		current_state = PlayerState.CAST
		cast_stage = CastStage.START
		return
	
	# skip input detection if casting
	if current_state == PlayerState.CAST:
		return
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction > 0:
			fireball_spawn.position.x = abs(fireball_spawn.position.x)
			facing_left = false
	elif direction < 0:
			facing_left = true
			fireball_spawn.position.x = -abs(fireball_spawn.position.x) 
			
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION)

func update_movement(delta):
	if (is_on_floor() || cayote_timer.time_left > 0) && jump_buffer_timer.time_left > 0:
		velocity.y = JUMP_VELOCITY
		current_state = PlayerState.JUMP
		jump_buffer_timer.stop()
	
	if current_state == PlayerState.JUMP:
		velocity.y += GRAVITY * delta
	else:
		velocity.y += GRAVITY * DOWN_GRAVITY_FACTOR * delta
	if current_state == PlayerState.CAST:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		return  # prevent other movement updates

		
func update_animation() -> void:
	if current_state == PlayerState.CAST || current_state == PlayerState.RELEASE:
		movement_sprite.hide()
		attack_sprite.show()
	else:
		angle_input.enable(false)
		movement_sprite.show()
		attack_sprite.hide()
		
	if velocity.x != 0:
		movement_sprite.scale.x = sign(velocity.x)
		attack_sprite.scale.x = sign(velocity.x)
	
	match current_state:
		PlayerState.IDLE: movement_sprite.play("idle")
		PlayerState.WALK: movement_sprite.play("run")
		PlayerState.JUMP: movement_sprite.play("rising")
		PlayerState.DOWN: movement_sprite.play("falling")
		PlayerState.CAST: attack_sprite.play("charge")
		PlayerState.RELEASE: attack_sprite.play("release")

func update_states() -> void:
	match current_state:
		PlayerState.IDLE when velocity.x != 0:
			current_state = PlayerState.WALK
			
		PlayerState.WALK:
			if velocity.x == 0:
				current_state = PlayerState.IDLE
			if not is_on_floor() && velocity.y > 0:
				current_state = PlayerState.DOWN
				cayote_timer.start()
		
		PlayerState.JUMP when velocity.y > 0:
			current_state = PlayerState.DOWN
		
		PlayerState.DOWN when is_on_floor():
			if velocity.x == 0:
				current_state = PlayerState.IDLE
			else:
				current_state = PlayerState.WALK
		
		PlayerState.CAST when cast_stage == CastStage.RELEASE:
			current_state = PlayerState.RELEASE
		PlayerState.RELEASE:
			cast_expire_timer.stop()	
			summon_fireball()
			current_state = PlayerState.IDLE
				
func update_attack_states() -> void:
	if current_state == PlayerState.CAST:
		match cast_stage:
			CastStage.START:
				cast_expire_timer.start()
				angle_input.enable(true)
				cast_stage = CastStage.ANGLE_INPUT  # move to next stage
				print("Started casting... waiting for angle input")
			CastStage.ANGLE_INPUT:
				# print(cast_expire_timer.time_left)
				if cast_expire_timer.time_left <= 0:
					_on_cast_expire_timeout()
					return

				# input details is handled by _on_angle_submitted()
			CastStage.SPEED_INPUT:
				# print(cast_expire_timer.time_left)
				if cast_expire_timer.time_left <= 0:
					_on_cast_expire_timeout()
					return
				
				# change of cast_stage is handled by _on_speed_submitted()
			CastStage.RELEASE:
				# exit cast loop
				cast_stage = CastStage.STOP
				current_state = PlayerState.RELEASE

func _on_cast_expire_timeout():
	print("Cast failed (time expired)")
	angle_input.enable(false)
	speed_input.enable(false)
	
	cast_stage = CastStage.STOP
	current_state = PlayerState.IDLE
	
func _on_angle_submitted(value: String) -> void:
	angle_input.enable(false)
	speed_input.enable(true)
	
	print("Angle submitted:", value)
	fireball_angle = float(value)
	
	cast_stage = CastStage.SPEED_INPUT
	# refresh timer
	cast_expire_timer.start()
	print("... waiting for speed input")
	
func _on_speed_submitted(value: String) -> void:
	speed_input.enable(false)
	
	fireball_speed = float(value)
	
	print("Speed Submitted:", value)
	cast_stage = CastStage.RELEASE
	# refresh timer
	cast_expire_timer.start()

func summon_fireball():
	var fireball_scene = preload("res://Scenes/fireball.tscn")
	var fireball = fireball_scene.instantiate()
	fireball.global_position = fireball_spawn.global_position
	
	fireball.angle_deg = fireball_angle
	fireball.speed = fireball_speed
	
	fireball.facing_left = facing_left
	get_parent().add_child(fireball)
