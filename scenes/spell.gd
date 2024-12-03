extends Area2D

class_name spell

@export var damage:float = 0
@export var turns:int = 1
@export var effect:int = 0

@onready var AnimPlayer = $AnimationPlayer

var animEnd:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if effect == 1:
		$Sprite2D.color = Color('#ff0000')
	elif effect == 2:
		$Sprite2D.color = Color('#00ff00')
	elif effect == 3:
		$Sprite2D.color = Color('#0000ff')
	elif effect == 4:
		$Sprite2D.color = Color('#ff00ff')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animEnd:
		get_parent().spellDelate()

func _on_animation_player_animation_finished(anim_name:String) -> void:
	animEnd = true
	$Sprite2D2.visible = false
