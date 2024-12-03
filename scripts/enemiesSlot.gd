extends Panel

@export var ID:int
@onready var styleBox = StyleBoxFlat.new()
@onready var spel:PackedScene = load("res://scenes/spell.tscn")

var mouse:bool = false
var cSpell:Array
var selfSpell:spell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	styleBox = StyleBoxFlat.new()
	styleBox.bg_color = Color("666666")
	connect("mouse_entered", self.mouse_entered)
	connect("mouse_exited", self.mouse_exited)
	SignalBus.connect("castSpell", Callable(self, 'castSpell'))
	SignalBus.connect("checkTurn", Callable(self, 'checkTurn'))

func mouse_entered():
	if cSpell.size() <= 0:
		add_theme_stylebox_override('panel', styleBox)
	mouse = true

func mouse_exited():
	if cSpell.size() <= 0:
		remove_theme_stylebox_override("panel")
	mouse = false

func castSpell(spellVars: Array) -> void:
	if mouse:
		if cSpell.size() > 0: #odznaczenie bo wczesniej był spell
			remove_theme_stylebox_override("panel")
			cSpell.clear()
			SignalBus.SubFromList.emit(ID)
		elif cSpell.size() <= 0 and spellVars[5] > 0: #zaznaczenie bo wcześniej nie było spella
			add_theme_stylebox_override('panel', styleBox)
			cSpell = spellVars
			SignalBus.AddToList.emit(ID)

func Attack():
	if selfSpell == null:
		var newSpell:spell = spel.instantiate()
		newSpell.damage = cSpell[0]
		newSpell.turns = cSpell[1]
		newSpell.effect = cSpell[2]
		add_child(newSpell)
		selfSpell = newSpell

func spellDelate():
	cSpell = []
	selfSpell.queue_free()
	selfSpell = null
	remove_theme_stylebox_override("panel")
	
func checkTurn():
	if selfSpell != null:
		selfSpell.turns -= 1
