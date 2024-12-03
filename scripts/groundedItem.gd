extends Node2D

@export var item:InventorySlot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = item.item.Sprite

#AddingItem
func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.name == 'PlayerCollision':
		var cInventory = area.get_parent().inventory
		var cSlot = 0
		var emptySlot = -1
		var stackableItemSlot = -1
		for i in cInventory.items:
			if i.item == null:
				if emptySlot == -1:
					emptySlot = cSlot
			elif item.item.Stackable:
				if i.item.Name == item.item.Name and i.amount < 100:
					stackableItemSlot = cSlot
			cSlot += 1
		
		if stackableItemSlot != -1 and cInventory.items[stackableItemSlot].amount + item.amount <= 100:
			cInventory.items[stackableItemSlot].amount += item.amount
			self.queue_free()
			Gfad.InventoryUpdate()
		elif stackableItemSlot != -1 and emptySlot != -1:
			
			var operations = 100 - cInventory.items[stackableItemSlot].amount
			
			cInventory.items[stackableItemSlot].amount += operations
			item.amount -= operations
			cInventory.items[emptySlot] = item
			self.queue_free()
			Gfad.InventoryUpdate()
			
			
		elif emptySlot != -1:
			cInventory.items[emptySlot] = item
			self.queue_free()
			Gfad.InventoryUpdate()
		
