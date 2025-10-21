extends Node

@onready var readyLabelPath = preload("res://Scenes/world/readyLabel.tscn");
@onready var setupInputsPath = preload("res://Scenes/world/setupInputs.tscn");

@onready var player1 = $"Level 1/Player";
var label: Control
var setupInputs:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handleLabel()
	handleSetupInputs()
	pass


func handleLabel() -> void:
	if Globals.gameState == Globals.GAMESTATE.READY and label == null:
		label = readyLabelPath.instantiate()
		player1.add_child(label)
	if Input.is_action_just_pressed("cast_spell") and Globals.gameState == Globals.GAMESTATE.READY:
		Globals.gameState = Globals.GAMESTATE.SETUP
		label.free()		
		
func handleSetupInputs() -> void:
	if Globals.gameState == Globals.GAMESTATE.SETUP and setupInputs == null:
		setupInputs = setupInputsPath.instantiate()
		player1.add_child(setupInputs)
	elif Globals.gameState == Globals.GAMESTATE.FIRE and setupInputs != null :
		setupInputs.free()

	#if Input.is_action_just_pressed("cast_spell") and Globals.gameState == Globals.GAMESTATE.SETUP:
		#Globals.gameState = Globals.GAMESTATE.SETUP
		#label.free()		
		#
