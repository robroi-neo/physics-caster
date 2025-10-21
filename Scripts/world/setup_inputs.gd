extends Control
@onready var rotationLineEdit: LineEdit = $RotationLineEdit
@onready var speedLineEdit: LineEdit = $speedLineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cast_spell") and rotationLineEdit.has_focus():
		speedLineEdit.edit()
		print(rotationLineEdit.is_editing())
	elif Input.is_action_just_pressed("cast_spell") and speedLineEdit.has_focus():
		print("yessir")
		Globals.gameState = Globals.GAMESTATE.FIRE
	
		
	
