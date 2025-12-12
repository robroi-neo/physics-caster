extends Camera2D

@export var zoom_speed := 0.06
@export var min_zoom := 1.3
@export var max_zoom := 2.8

@export var starting_zoom := 2

@export var left_limit := -185
@export var top_limit := -1025
@export var right_limit := 4067
@export var bottom_limit := 740

func _ready():
	limit_left = left_limit
	limit_top = top_limit
	limit_right = right_limit
	limit_bottom = bottom_limit
	
	zoom.x = starting_zoom
	zoom.y = starting_zoom

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:  # zoom in
			zoom += Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:  # zoom out
			zoom -= Vector2(zoom_speed, zoom_speed)

		# clamp zoom value
		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = zoom.x
