extends Node

var currentItem:InventorySlot
var currentItemObj:Node2D

var camera:Camera2D
var playerInv:Inventory
var npcCords:Array
var tilesize = 96

var questList:Array

var slotIMG = load("res://assets/UI/slots/slot.png")
var slothoveredIMG = load("res://assets/UI/slots/slotHovered.png")

var playerStats:Dictionary
var invOpen:bool = false 

var CLASS:int = 0

signal addItemToInventory

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	currentItem = null

func readyToPlay():
	for i in get_tree().get_nodes_in_group('Player'):
		playerInv = i.inventory
		camera = i.get_node('Camera2D')
		InventoryUpdate()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('escape'):
		get_tree().quit()
	if currentItem != null:
		currentItemObj.get_node('Label').text = str(currentItem.amount)
		currentItemObj.position = camera.get_local_mouse_position() - Vector2(32,32)
	
func removeFromInventory(ID:int):
	playerInv.items[ID] = InventorySlot.new()

func AddToInventory(invSlot, ID):
	playerInv.items[ID] = invSlot

func InventoryUpdate():
	var cSlot = 0
	
	if playerInv != null: for i in playerInv.items:
		
		if i.item != null:
			for slotChecking in get_tree().get_nodes_in_group('Slot'):
				if slotChecking.ID == cSlot:
					slotChecking.inventorySlot = i
				
				slotChecking.update()
	
		cSlot += 1
		
func updateStats():
	
	playerStats.clear()
	
	var chestPlate = get_tree().get_nodes_in_group('ChestPlateSlot')[0].get_child(0)
	var Sword = get_tree().get_nodes_in_group('WeaponSlot')[0].get_child(0)
	
	if chestPlate:
		readStatsFromDictionary(chestPlate.item.Statistics.Stats)
	
	if Sword:
		readStatsFromDictionary(Sword.item.Statistics.Stats)
	
func readStatsFromDictionary(statsDic:Dictionary):
	var exist:bool = false
	for x in statsDic:
		for y in playerStats:
			if x == y:
				playerStats[y] += statsDic[x]
				exist = true
		if exist == false:
			playerStats[x] = statsDic[x]
		exist = false


func _on_dialogic_signal(argument:String):
	if argument == "emillyQuestAccept":
		questList.append('Kocia niespodzianka')
		emit_signal('addItemToInventory')
