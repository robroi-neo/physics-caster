extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect Triggers and Targets Here
	$Triggers/Trigger_1.activated.connect($Triggers_Platform/Platform_1.activate)
	$Triggers/Trigger_2.activated.connect($Triggers_Platform/Platform_2.activate)
	# Trigger_3 activates multiple platforms
	$Triggers/Trigger_3.activated.connect(showBridge)
	
func showBridge() -> void:
	$Triggers_Platform/Platform_Bridge.visible = true
	$Triggers_Platform/Platform_Bridge.set_collision_enabled(true)
