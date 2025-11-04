extends Node2D
var play_time = 0;
@onready var duration = $HBoxContainer/Duration
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(play_time)
	duration.text = format_time(play_time)

func format_time(seconds: int) -> String:
	var minutes = seconds / 60
	var secs = seconds % 60
	return "%d:%02d" % [minutes, secs]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level/level.tscn")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	pass # Replace with function body.
