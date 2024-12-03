extends Node2D

@export var item:Item
@export var Sprite:Texture2D
@export var Amount:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = Sprite
	if Amount > 1:
		$Label.visible = true
		$Label.text = str(Amount)
	else:
		$Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Gfad.invOpen:
		$Sprite.texture = Sprite
		if Amount > 1:
			$Label.visible = true
			$Label.text = str(Amount)
		else:
			$Label.visible = false
