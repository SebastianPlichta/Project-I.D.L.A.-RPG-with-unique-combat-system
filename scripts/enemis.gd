extends Area2D

@export var hp:float = 100.0
@export var damage = 5
@export var type = 1

@onready var grid = get_node('../GridContainer')

@onready var hpBar = ProgressBar.new()
@onready var styleBox = StyleBoxFlat.new()
@onready var timer = $Timer

var iterateGrid:bool = false
var ableToMove:Array
var debuffArray:Array = []

func _ready() -> void:
	timer.start()
	hpBar.custom_minimum_size = Vector2(96,30)
	hpBar.position = Vector2(32,-32)
	styleBox.bg_color = Color("#2db800")
	hpBar.add_theme_stylebox_override('fill', styleBox)
	hpBar.value = hp
	add_child(hpBar)
	SignalBus.connect("checkTurn", Callable(self, 'checkTurn'))
	
func _process(delta: float) -> void:
	if !iterateGrid:
		for i in grid.get_children():
			ableToMove.append(i.position)
		iterateGrid = true
		position = ableToMove[randi_range(0,8)] + grid.position
	
	hpBar.value = hp

func _on_timer_timeout() -> void:
	timer.start()
	position = ableToMove[randi_range(0,8)] + grid.position
	
func checkTurn():
	for i in debuffArray:
		if i['turns'] > 0:
			hp -= i['damage']
			i['turns'] -= 1
		elif i['turns'] <= 0:
			debuffArray.erase(i)
	
	for i in get_overlapping_areas():
		if 'selfSpell' in i.get_parent() and i.name == 'Grid':
			for spells in get_tree().get_nodes_in_group('spell'):
				if spells == i.get_parent().selfSpell:
					hp -= spells.damage
					if spells.effect > 0:
						debuffArray.append({
							
							'turns': spells.turns,
							'damage': spells.damage
							
						})
				
