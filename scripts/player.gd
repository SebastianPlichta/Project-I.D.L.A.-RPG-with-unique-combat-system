extends Node2D

@export var inventory:Inventory

@onready var Sprite = $ChooseClass/IMG
@onready var AnimPlayer = $ChooseClass/AnimationPlayer
@onready var tiles = get_node('../collisionLayer')
@onready var tilesize = Gfad.tilesize

var cords:Vector2
var State
var speed = 0.35
var moving = false
var canInteracte:bool = false
var cnpc:npc

func _ready() -> void:
	Gfad.connect("addItemToInventory", Callable(self , "_addItemToInventory"))
	position = Vector2(5*tilesize,15*tilesize)

func _process(delta: float) -> void:
	$"fps counter".text = 'FPS: ' + str(Engine.get_frames_per_second())
	
	State = 1
	
	$Label.text = "Statistics"
	for x in Gfad.playerStats:
		$Label.text += str(x, " ", Gfad.playerStats[x], "\n")
	
	if !moving:
		if Input.is_action_pressed("A"):
			AnimPlayer.play('WALKSIDE')
			Sprite.flip_h = true
			cords = Vector2.LEFT
		elif Input.is_action_pressed("D"):
			AnimPlayer.play('WALKSIDE')
			Sprite.flip_h = false
			cords = Vector2.RIGHT
		elif Input.is_action_pressed("W"):
			AnimPlayer.play('WALKBACK')
			cords = Vector2.UP
		elif Input.is_action_pressed("S"):
			AnimPlayer.play('WALKFRONT')
			cords = Vector2.DOWN
		else:
			State = 0
			if cords == Vector2.LEFT or cords ==  Vector2.RIGHT:
				AnimPlayer.play('IDLESIDE')
			elif cords == Vector2.UP:
				AnimPlayer.play('IDLEBACK')	
			else:
				AnimPlayer.play('IDLEFRONT')
	
	if State == 1:
		
		move()
		State = 0
	
	if Input.is_action_just_pressed('E'):
		$Inventory.visible = !$Inventory.visible
		Gfad.invOpen = !Gfad.invOpen
	elif Input.is_action_just_pressed('F') and cnpc:
		cnpc.interact()
		
	$Label.visible = Gfad.invOpen
	$PressF.visible = canInteracte
		
func move():
	if cords:
		if moving == false and tiles.get_cell_tile_data(position/tilesize + cords) == null:
			
			var npcDetected = false
			
			for x in Gfad.npcCords:
				if x == position/tilesize + cords:
					npcDetected = true
			if !npcDetected:
				moving = true
				var tween = create_tween()
				tween.tween_property(self, 'position', position + cords * tilesize, speed)
				tween.tween_callback(move_false)


func move_false():
	moving = false


func _on_player_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group('interactive'):
		canInteracte = true
		if area.is_in_group('npc'):
			cnpc = area.get_parent()


func _on_player_collision_area_exited(area: Area2D) -> void:
	if area.is_in_group('interactive'):
		canInteracte = false
		if area.is_in_group('npc'):
			cnpc = null
			
func _addItemToInventory():
	var cSlot = 0
	var emptySlot = -1
	var stackableItemSlot = -1
	var item = InventorySlot.new()
	item.item = load("res://Resources/QuestItem/KittenToy.tres")
	item.amount = 1
	for i in inventory.items:
		if i.item == null:
			if emptySlot == -1:
				emptySlot = cSlot
			elif item.item.Stackable:
				if i.item.Name == item.item.Name and i.amount < 100:
					stackableItemSlot = cSlot
		cSlot += 1
		
		if stackableItemSlot != -1 and inventory.items[stackableItemSlot].amount + item.amount <= 100:
			inventory.items[stackableItemSlot].amount += item.amount
			Gfad.InventoryUpdate()
		elif stackableItemSlot != -1 and emptySlot != -1:
			
			var operations = 100 - inventory.items[stackableItemSlot].amount
			
			inventory.items[stackableItemSlot].amount += operations
			item.amount -= operations
			inventory.items[emptySlot] = item
			Gfad.InventoryUpdate()
			
			
		elif emptySlot != -1:
			inventory.items[emptySlot] = item
			Gfad.InventoryUpdate()
