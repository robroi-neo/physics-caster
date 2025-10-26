extends Node2D

@export var player: Node2D
@onready var label = $HBoxContainer/Label
@onready var input = $HBoxContainer/LineEdit
@onready var expire_time = $expire_time

@export var label_text: String

signal input_submitted(angle_value: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enable(false)
	label.text = label_text
	print("assigned to player:", player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# follow player
	if player:
		global_position = player.global_position + Vector2(-25, -65)
	else:
		enable(false)

func _on_line_edit_text_submitted(new_text: String) -> void:
	emit_signal("input_submitted", new_text)
	
func enable(active: bool):
	visible = active
	label.mouse_filter = Control.MOUSE_FILTER_STOP if active else Control.MOUSE_FILTER_IGNORE
	input.mouse_filter = Control.MOUSE_FILTER_STOP if active else Control.MOUSE_FILTER_IGNORE
	
	if active:
		input.grab_focus()
		input.caret_column = input.text.length()
	else:
		input.clear()


func _on_line_edit_text_changed(new_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("^-?[0-9]*\\.?[0-9]*$")
	if not regex.search(new_text):
		input.text = new_text.left(new_text.length() - 1)
