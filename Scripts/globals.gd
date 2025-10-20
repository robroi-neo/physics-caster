extends Node

enum PlayerName { PLAYER_1,PLAYER_2}
enum GAMESTATE {READY,SETUP,FIRE}


var playerName = PlayerName.PLAYER_1
var gameState = GAMESTATE.READY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
