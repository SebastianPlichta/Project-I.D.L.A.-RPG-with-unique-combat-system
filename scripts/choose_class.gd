extends Node2D

@export var classID:int

@onready var druidIMG:Texture2D = load("res://assets/npc/druidAnimation.png")
@onready var knightIMG:Texture2D = load("res://assets/npc/knightAnimation.png")
@onready var mageIMG:Texture2D = load("res://assets/npc/mageAnimation.png")
@onready var rougeIMG:Texture2D = load("res://assets/npc/rougeAnimation.png")
@onready var classIMGLIST:Array = [druidIMG,knightIMG,mageIMG,rougeIMG]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changeClass(Gfad.CLASS)

func changeClass(classID):
	$IMG.texture = classIMGLIST[classID]
	
