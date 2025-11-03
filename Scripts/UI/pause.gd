extends Node2D


func resume():
	get_tree().paused = false
	visible = false
func pause():
	get_tree().paused = true
	visible = true
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		print("real")
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false  # Start hidden
	set_process_input(false)  # Disable input when hidden
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testEsc()
	pass


func _on_resume_pressed() -> void:
	resume()
	pass # Replace with function body.




func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn");
	pass # Replace with function body.
