extends Node

enum PlayerName { PLAYER_1,PLAYER_2}
enum GAMESTATE {READY,SETUP,FIRE,RELEASE}


var playerName = PlayerName.PLAYER_1
var gameState = GAMESTATE.READY
var speed:int = 0
var rotation:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
