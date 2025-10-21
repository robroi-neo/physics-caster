extends Control

func _process(delta: float) -> void:
	pass


func _on_tutorial_pressed() -> void:
	print("tutorial pressed")

func _on_arena_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/arena.tscn")
	print("arena pressed")

func _on_exit_pressed() -> void:
	get_tree().quit()
