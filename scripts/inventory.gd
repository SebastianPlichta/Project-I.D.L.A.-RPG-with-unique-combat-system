extends Control

@export var inventory:Inventory = preload("res://Resources/playerInventory.tres")


var slotNumb = 29

func _ready() -> void:
	
	var cSlot = 0
	
	var gridContainer = $HBoxContainer/VBoxContainer/GridContainer
	var slot = load("res://scenes/slot.tscn")
	for i in slotNumb:	
		cSlot += 1
		var slotInstance = slot.instantiate()
		slotInstance.ID = cSlot
		gridContainer.add_child(slotInstance)
		
	Gfad.InventoryUpdate()
