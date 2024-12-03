extends TextureRect

@export var inventorySlot:InventorySlot
@export var ID:int

var hover:bool = false
var iteminloop
var itemInstance
var itemto
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itemto = get_tree().get_nodes_in_group('Player')[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_just_pressed('LeftClick') and hover:
		if inventorySlot != null and Gfad.currentItem == null: #grab from slot
			Gfad.currentItem = inventorySlot
			inventorySlot = null
			Gfad.currentItemObj = get_node('Item')
			remove_child(Gfad.currentItemObj)
			itemto.add_child(Gfad.currentItemObj)
			Gfad.currentItemObj.position = Gfad.camera.get_local_mouse_position() - Vector2(32,32)
			Gfad.removeFromInventory(ID)
			update()
			
		elif inventorySlot == null and Gfad.currentItem != null: #place to slot
			if !is_in_group('StatSlot'):
				placeToSlot()
			elif is_in_group('ChestPlateSlot') and Gfad.currentItem.item.Statistics["Type"] == 1:
				placeToSlot()
			elif is_in_group('WeaponSlot') and Gfad.currentItem.item.Statistics["Type"] == 2:
				placeToSlot()
		
		elif inventorySlot != null and Gfad.currentItem != null and !is_in_group('StatSlot'):
			if !Gfad.currentItem.item.Stackable or Gfad.currentItem.item.Name != inventorySlot.item.Name:
				iteminloop = Gfad.currentItem
				Gfad.currentItem = inventorySlot
				inventorySlot = iteminloop
				Gfad.currentItemObj.queue_free()
				Gfad.currentItemObj = get_node('Item')
				remove_child(Gfad.currentItemObj)
				itemto.add_child(Gfad.currentItemObj)
				Gfad.currentItemObj.position = Gfad.camera.get_local_mouse_position() - Vector2(32,32)
				Gfad.removeFromInventory(ID)
				Gfad.AddToInventory(inventorySlot, ID)
				update()
			elif Gfad.currentItem.item.Stackable and inventorySlot.amount + Gfad.currentItem.amount <= 100:
				iteminloop = Gfad.currentItem.amount
				Gfad.currentItem = null
				inventorySlot.amount += iteminloop
				Gfad.currentItemObj.queue_free()
				Gfad.removeFromInventory(ID)
				Gfad.AddToInventory(inventorySlot, ID)
				update()
			elif Gfad.currentItem.item.Stackable:
				iteminloop = 100 - inventorySlot.amount
				inventorySlot.amount += iteminloop
				Gfad.currentItemObj.Amount -= iteminloop
				Gfad.currentItem.amount -= iteminloop
				Gfad.removeFromInventory(ID)
				Gfad.AddToInventory(inventorySlot, ID)
				update()
			
				
			

func update():
	if inventorySlot != null:
		if self.get_child_count() < 1:
			var itemTemplate = preload("res://scenes/ItemTemplate.tscn")
			itemInstance = itemTemplate.instantiate()
			add_child(itemInstance)
		itemInstance.item = inventorySlot.item
		itemInstance.Sprite = inventorySlot.item.Sprite
		itemInstance.Amount = inventorySlot.amount
	else:
		for i in get_children():
			i.queue_free()
	
	if is_in_group('StatSlot'):		
		Gfad.updateStats()
	
	
		
func _on_mouse_entered() -> void:
	texture = Gfad.slothoveredIMG
	hover = true


func _on_mouse_exited() -> void:
	texture = Gfad.slotIMG
	hover = false
	
func placeToSlot():
	inventorySlot = Gfad.currentItem
	Gfad.currentItemObj.queue_free()
	Gfad.currentItem = null
	Gfad.AddToInventory(inventorySlot, ID)
	update()
