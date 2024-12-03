extends Node2D

class_name npc

@export var Sprite:Texture2D
@export var ColRow:Vector2
@export var frameCount:int
@export var StartingDialogue:String
@export var Position:Vector2

@onready var time = $Timer
@onready var sprite = $Sprite2D

var currentFrame = 0

func _ready() -> void:
	sprite.texture = Sprite
	sprite.hframes = ColRow.x
	sprite.vframes = ColRow.y
	time.start(0.25)
	Gfad.npcCords.append(Position)
	position = Position * Gfad.tilesize

func _process(delta: float) -> void:
	sprite.frame = currentFrame


func _on_timer_timeout() -> void:
	if currentFrame + 1 <= frameCount:
		currentFrame += 1
	else:
		currentFrame = 0
	time.start(0.25)
	
func interact():
	Dialogic.start(StartingDialogue)
