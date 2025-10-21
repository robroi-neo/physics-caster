extends Node

enum PlayerName { PLAYER_1,PLAYER_2}
enum GAMESTATE {READY,SETUP,FIRE,RELEASE}

var playerName = PlayerName.PLAYER_1
var gameState = GAMESTATE.READY
var speed:int = 0
var rotation:int = 0
