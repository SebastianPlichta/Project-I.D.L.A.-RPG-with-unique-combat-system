extends Node2D

@export var row:int
@export var collumns:int
@export var path:String
@export var pathobj:String

@onready var backgroundLayer:TileMapLayer = $backgroundLayer
@onready var topLayer:TileMapLayer = $topLayer
@onready var collisionLayer:TileMapLayer = $collisionLayer
@onready var interactiveLayer:TileMapLayer = $interactiveLayer
@onready var tilemap:Array = [backgroundLayer,topLayer,collisionLayer]
@onready var groundedItems:PackedScene = load("res://scenes/grounded_item.tscn")
@onready var teleporter:PackedScene = load("res://scenes/teleporter.tscn")
@onready var npc:PackedScene = load("res://scenes/npc.tscn")
var oldPath:String = " "
var oldPathobj:String = " " 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadMap(path,pathobj)
	Gfad.readyToPlay()

func _process(delta: float) -> void:
	pass

func loadMap(spath,spathobj):
	var file:FileAccess = FileAccess.open(spath,FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	json.parse(json_string)
	var mapData = json.data
	
	for i in range(tilemap.size()):
		var currentLayer:TileMapLayer = tilemap[i]
		currentLayer.clear()
		for tile in mapData[str(i)]:
			var pos = text_to_vector2(tile['position'])
			var atlasCords = text_to_vector2(tile['tile_id'])
			currentLayer.set_cell(pos,4,atlasCords)
	
	file = FileAccess.open(spathobj,FileAccess.READ)
	json_string = file.get_as_text()
	file.close()
	
	for child in $obj.get_children():
		child.queue_free()
	
	json.parse(json_string)
	var objData = json.data
	for x:Dictionary in objData:
		if x.has('item'):
			var newItem = groundedItems.instantiate()
			var newInvSlot = InventorySlot.new()
			var item = Item.new()
			item.Name = x['item'][0][0]
			item.Description = x['item'][0][1]
			item.Statistics = x['item'][0][2]
			item.Sprite = load(x['item'][0][3])
			item.Stackable = x['item'][0][4]
			newInvSlot.item = item
			newInvSlot.amount = x['item'][1]
			newItem.item = newInvSlot
			newItem.position = text_to_vector2(x['position'])
			$obj.add_child(newItem)
		elif x.has('place'):
			var newTeleporter = teleporter.instantiate()
			newTeleporter.place = x['place']
			newTeleporter.place2 = x['place2']
			newTeleporter.position = text_to_vector2(x['position'])
			$obj.add_child(newTeleporter)
		elif x.has('StartingDialogue'):
			var newNpc = npc.instantiate()
			newNpc.Sprite = load(x['Sprite'])
			newNpc.ColRow = text_to_vector2(x['ColRow'])
			newNpc.frameCount = x['frameCount']
			newNpc.StartingDialogue = x['StartingDialogue']
			newNpc.Position = text_to_vector2(x['position'])
			$obj.add_child(newNpc)
			
func SaveMap(spath,spathobj):
	#Declarate Vars
	var cLayerArray:Array
	var json:JSON = JSON.new()
	var jsonString
	var file:FileAccess = FileAccess.open(spath,FileAccess.WRITE)
	
	var i = 0
	var mapData = {
		"row": row,
		"collumns": collumns,
	}
	
	#Read current map
	for currentLayer:TileMapLayer in tilemap:
		cLayerArray = []
		for x in range(row):
			for y in range(collumns):
				var cTile = currentLayer.get_cell_atlas_coords(Vector2(x,y))
				if cTile != Vector2i(-1,-1):
					cLayerArray.append({
						"position": Vector2(x, y),
						"tile_id": cTile
					})
		mapData[i] = cLayerArray
		i += 1
		
	jsonString = JSON.stringify(mapData, "\t")
	file.store_string(jsonString)
		
	file.close()
	file = FileAccess.open(spathobj,FileAccess.WRITE)
	
	var objects_data = []
	for child in $obj.get_children():
		if "item" in child:
			var object_data = {
				"item": [[child.item.item.Name, child.item.item.Description, child.item.item.Statistics, child.item.item.Sprite.resource_path, child.item.item.Stackable], child.item.amount],
				"position": child.position,
			}
			objects_data.append(object_data)
		elif 'place' in child:
			var object_data = {
				"place": child.place,
				"place2": child.place2,
				"position": child.position,
			}
			objects_data.append(object_data)
		elif 'StartingDialogue' in child:
			var object_data = {
				'Sprite': child.Sprite.resource_path,
				'ColRow': child.ColRow,
				'frameCount': child.frameCount,
				'StartingDialogue': child.StartingDialogue,
				'position': child.Position
			}
			objects_data.append(object_data)
	
	jsonString = JSON.stringify(objects_data, "\t")
	if jsonString != null:
		file.store_string(jsonString)
	file.close()

func text_to_vector2(input_string: String) -> Vector2:
	# Usuwamy nawiasy
	var cleaned_string = input_string.replace("(", "").replace(")", "")  # Usuwamy nawiasy
	var parts = cleaned_string.split(",")  # Dzielimy tekst po przecinku
	
	# Przekształcamy części na liczby
	var x = int(parts[0].strip_edges())  # Zamieniamy pierwszy element na int
	var y = int(parts[1].strip_edges())  # Zamieniamy drugi element na int
	
	return Vector2(x, y)

func changeScene(to:String, toobj:String, selfTP):
	SaveMap(path,pathobj)
	selfTP.queue_free()
	path = to
	pathobj = toobj
	loadMap(path,pathobj)
