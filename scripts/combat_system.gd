extends Node2D

@onready var slotForEnemy:PackedScene = load("res://scenes/slotForEnemys.tscn")

@onready var crystals:Texture2D = load("res://assets/combatSystem/crystals.png")
@onready var symbols:Texture2D = load("res://assets/combatSystem/symbols.png")
@onready var sigils:Texture2D = load("res://assets/combatSystem/sigil.png")

@onready var enemy = $VBoxContainer/Enemis/Node2D
@onready var chooseHeader = $VBoxContainer/FightMenu/MainRows/HeadersCol/SpellCreate
@onready var subchooseHeader = $VBoxContainer/FightMenu/MainRows/SubHeaderCol/ChooseCrystalsLabel
@onready var descriptionHeader = $VBoxContainer/FightMenu/MainRows/SubHeaderCol/elementName
@onready var description = $VBoxContainer/FightMenu/MainRows/SubRows/StatsTxt/Description
@onready var stats = $VBoxContainer/FightMenu/MainRows/SubRows/StatsTxt/Stats
@onready var createMenu = $VBoxContainer/FightMenu/MainRows
@onready var spellCastMenu = $VBoxContainer/FightMenu/MainRows2
@onready var preview = $VBoxContainer/FightMenu/MainRows/SubRows/PreviewIMG/spellElements
@onready var turnsCounter = $VBoxContainer/EnemisStats/turnsCounter
@onready var doubleCast = $doubleCast

var crystalsInfo:Dictionary = {
	
	'0' = {
		
		'name': 'Czerwony kryształ',
		'Description': 'Czerwony kryształ wykonany z rubinu znalezionego niedaleko WOYCITY wykorzystując siłe broni właściciela nadaje zaklęciu moc zadawania obrażeń fizycznych',
		'Statistics': {
			
			'AD': '10',	
			'AP': '0',
		},
	},
	
	'1' = {
		
		'name': 'Niebieski kryształ',
		'Description': 'Niebieski kryształ znaleziony przy jednym z drzew na obrzerzach stolicy przesiąkniety mocą bogów nadaje zaklęciu moc zadawania obrażeń magicznych',
		'Statistics': {
			
			'AD': '0',
			'AP': '10',	
		},
	},
	
	'2' = {
		
		'name': 'Brązowy kryształ',
		'Description': 'Brązowy kryształ to wynalazek najwybitniejszych naukowców z małego miasteczka niedaleko PORTU HOLING po przez zjednanie mocy czerwonego oraz niebieskiego kryształu nadaje zaklęciu zdolnośc zadawania obrażeń hybrydowych',
		'Statistics': {
			
			'AD': '5',
			'AP': '5',	
		},
	},
	
}

var symbolsInfo:Dictionary = {
	
	'0': {
		
		'name': 'Podstawowy symbol obrażeń fizycznych',
		'Description': 'Swoją mocą nadaje zaklęciu możliwość zranienia przeciwnika',
		'effect': ['instancja obrażeń wymierzona w jeden cel x1.5 Obrażeń fizycznych'],
		'Statistics': {
			
				'ADX': '1.5',
		},
	},
	
	'1': {
		
		'name': 'Podstawowy symbol obrażeń magicznych',
		'Description': 'Swoją mocą nadaje zaklęciu możliwość zranienia przeciwnika',
		'effect': ['instancja obrażeń wymierzona w jeden cel x1.5 Obrażeń magicznych'],
		'Statistics': {
			
				'APX': '1.5',
		},
	},
	
	'2': {
		
		'name': 'Podstawowy symbol klątwy trucizny',
		'Description': 'Swoją mocą nadaje zaklęciu możliwość nałożenia klątwy trucizny na przeciwnika',
		'effect': ['nałożenie klątwy TRUCIZNY na 3 tury x0.2 Obrażeń hybrydowych'],
		'Statistics': {
			
			'ADAPX': '0.2',
			'turns': '3',
			'curse': '1',
			
		}
	},
	'3': {
		
		'name': 'Podstawowy symbol zamrożenia',
		'Description': 'Swoją mocą nadaje zaklęciu możliwość zamrożenia oraz słabego zranienia przeciwnika',
		'effect': ['instancja obrażeń wymierzona w jeden cel x0.2 Obrażeń hybrydowych', 'zamrożenie jednego celu na 1 ture'],
		'Statistics': {
			
			'ADAPX': '0.2',
			'turns': '1',
			'curse': '2',
			
		}
	},
	'4': {
		
		'name': 'Podstawowy symbol ognia',
		'Description': 'Swoją mocą nadaje zaklęciu możliwość nałożenia ognia na przeciwnika',
		'effect': ['nałożenie klątwy OGNIA na 3 tury x0.5 Obrażeń fizycznych'],
		'Statistics': {
			
			'ADX': '0.5',
			'turns': '3',
			'curse': '3',
			
		}
	},	
	
	'5': {
		
		'name': 'Podstawowy symbol obrażeń obszarowych',
		'Description': 'Swoją mocą nadaje zaklęciu możliwość zranienia wielu przeciwników do okoła na raz',
		'effect': ['instancja obrażeń 3 na 3 pola x0.11 Obrażeń magicznych'],
		'Statistics': {
			
			'APX': '0.11',
			'mx': '3',
			'my': '3',
			
		},
	},	
}

var sigilsInfo:Dictionary = {
	
	'0' : {
		
		'name' = 'Pieczęć zwiększonych obrażeń',
		'Description' = 'Zwieksza każdy typ obrażeń danego zaklęcia',
		'effect' = ['Obrażenia +10%'],
		'Statistics' = {
			
			'ADAPX': '1.10'
			
		}
		
	},
	'1' : {
		
		'name' = 'Pieczęć przedłużonego działania',
		'Description' = 'Zwiększa liczbe tur przez które działa zaklęcie turowe',
		'effect' = ['+1 tura'],
		
		'Statistics' = {
			
			'turns': '1'
			
		}
		
	},	
	'2' : {
		
		'name' = 'Pieczęć klonująca',
		'Description' = 'Rzuca dane zaklęcie dwukrotnie',
		'effect' = ['Podwójne zaklęcie'],
		'Statistics' = {
			
			'double': true
			
		}
	}

}

var curseInfo:Dictionary = {
	
	1: 'Nałożenie trucizny',
	2: 'Zamrożenie',
	3: 'Podpalenie',
	
}

var slots:Array

var mouse:bool
var click:bool
var phase:int = 1

var currentCrystal:int
var currentSymbol:int
var currentSigil:int

var currentSelect:int = -1

#SpellStats
var ap:float
var ad:float
var turns:int
var curse:int
var mTx:int = 1
var mTy:int = 1
var double:bool = false
var sTs:int = 1

var combatTurns:int = 1

var currentEnemySlot:Array
var currentSpellSlotID:Array

func _ready() -> void:
	
	for i in $VBoxContainer/FightMenu/MainRows/SubRows/slots.get_children():
		slots.append(i)
	
	for x in range(9):
		var newEnemySlot = slotForEnemy.instantiate()
		newEnemySlot.ID = x
		enemy.get_parent().get_node('GridContainer').add_child(newEnemySlot)
		currentEnemySlot.append(newEnemySlot)
		
	turnsCounter.text = str(combatTurns)
	
	SignalBus.connect("AddToList", Callable(self, 'AddToList'))
	SignalBus.connect('SubFromList', Callable(self,'SubFromList'))
	crystalPhase() 

func _process(delta: float) -> void:

	click = Input.is_action_just_pressed('LeftClick')
	
	if phase == 4:
		if enemy != null:
			if click:
				if double:
					SignalBus.castSpell.emit([ap+ad,turns+1,curse,mTx,mTy,sTs])
				else:
					SignalBus.castSpell.emit([ap+ad,turns,curse,mTx,mTy,sTs])	
				combatTurns += 1
				turnsCounter.text = str(combatTurns)
				
	if currentSelect != -1:
		
		checkElement(slots[currentSelect].get_meta('cItem'), phase)
		
		if phase == 1:
			if click:
				currentCrystal = slots[currentSelect].get_meta('cItem')
				drawSpellElement(getTextureFromAtlas(crystals,currentCrystal,16), Vector2(120,96))
				symbolsPhase()
		elif phase == 2:
			if click:
				currentSymbol = slots[currentSelect].get_meta('cItem')
				drawSpellElement(getTextureFromAtlas(symbols,currentSymbol,16), Vector2(120,70))
				sigilPhase()
		elif phase == 3:
			if click:
				currentSigil = slots[currentSelect].get_meta('cItem')
				drawSpellElement(getTextureFromAtlas(sigils,currentSigil,20), Vector2(120,120))
				castPhase()
				
func crystalPhase():
	
	preview.get_parent().remove_child(preview)
	for i in preview.get_children():
		i.queue_free()
	$VBoxContainer/FightMenu/MainRows/SubRows/PreviewIMG.add_child(preview)
	spellCastMenu.visible = false
	createMenu.visible = true
	phase = 1
	chooseHeader.text = "Menu Tworzenia Zaklęcia (1/3)"
	subchooseHeader.text = "Wybierz kryształ"
	var randomList = getRandomList(3,2)
	
	for i in range(slots.size()):
		slots[i].texture = getTextureFromAtlas(crystals,randomList[i],16)
		slots[i].set_meta('cItem', randomList[i])

func symbolsPhase():
	phase = 2
	chooseHeader.text = "Menu Tworzenia Zaklęcia (2/3)"
	subchooseHeader.text = "Wybierz symbol"
	var randomList = getRandomList(3,5)
	randomList = [1,2,5]
	for i in range(slots.size()):
		slots[i].texture = getTextureFromAtlas(symbols,randomList[i],16)
		slots[i].set_meta('cItem', randomList[i])
		
func sigilPhase():
	phase = 3
	chooseHeader.text = "Menu Tworzenia Zaklęcia (3/3)"
	subchooseHeader.text = "Wybierz pieczęć"
	var randomList = getRandomList(3,2)
	for i in range(slots.size()):
		slots[i].texture = getTextureFromAtlas(sigils,randomList[i],20)
		slots[i].set_meta('cItem', randomList[i])

func castPhase():
	phase = 4
	preview.get_parent().remove_child(preview)
	$VBoxContainer/FightMenu/MainRows2/SubRows/PreviewIMG.add_child(preview)

	spellCastMenu.visible = true
	createMenu.visible = false
	
	var crystalInfo = checkElement(currentCrystal, 1)['Statistics']
	var symbolInfo = checkElement(currentSymbol, 2)
	var sigilInfo = checkElement(currentSigil, 3)
	
	ap = float(crystalInfo['AP'])
	ad = float(crystalInfo['AD'])
	
	var infoArray:Array = [symbolInfo,sigilInfo]
	for i in infoArray:
		i = i['Statistics']
		for x in i:
			if x == 'ADX':
				ad = ad * float(i[x])
			elif x == 'APX':
				ap = ap * float(i[x])
			elif x == 'ADAPX':
				ap = ap * float(i[x])
				ad = ad * float(i[x])
			elif x == 'turns':
				turns += int(i[x])
			elif x == 'curse':
				curse = int(i[x])
			elif x == 'mx':
				mTx = int(i[x])
			elif x == 'my':
				mTy = int(i[x])
			elif x == 'double':
				double = i[x]
	
	var textPreview:String
	sTs = mTx*mTy
	
	if ad != 0.0:
		textPreview += '\nObrażenia fizyczne: ' + str(ad)
	if ap != 0.0:
		textPreview += '\nObrażenia magiczne: ' + str(ap)
	if curse != 0:
		textPreview += '\nEfekt: ' + curseInfo[curse]
		if turns !=  0:
			textPreview += '\nIlość tur: ' + str(turns)
	if double:
		textPreview += '\n Podwójne użycie '
		
	textPreview += '\nRozmiar: ' + str(mTx * mTy)
	
	$VBoxContainer/FightMenu/MainRows2/SubRows/StatsTxt/Description.text = textPreview
	$VBoxContainer/FightMenu/MainRows2/nextTurn.text = str(sTs) + " Następna tura"
	
func getRandomList(howMany:int, maxInt:int):
	var returnList:Array
	
	while returnList.size() != howMany:
		var exist = false
		var value = randi_range(0,maxInt*10)
		value = int(value/10)
		for i in returnList:
			if value == i:
				exist = true
				
		if exist == false:
			returnList.append(value)

	return returnList

func checkElement(index:int, phases:int):
	
	var info:Dictionary
	if phases == 1:
		for i in crystalsInfo:
			if i == str(index):
				info = crystalsInfo[i]
		descriptionHeader.text = info['name']
		description.text = info['Description']
		stats.text = 'Obrażenia fizyczne: ' + info['Statistics']['AD'] + ' \n Obrażenia Magiczne: ' + info['Statistics']['AP']
	
	if phases == 2:
		stats.text = ''
		for i in symbolsInfo:
			if i == str(index):
				info = symbolsInfo[i]
		descriptionHeader.text = info['name']
		description.text = info['Description']
		for i in info['effect']:
			stats.text += i + '\n'
	
	if phases == 3:
		stats.text = ''
		for i in sigilsInfo:
			if i == str(index):
				info = sigilsInfo[i]
		descriptionHeader.text = info['name']
		description.text = info['Description']
		for i in info['effect']:
			stats.text += i + '\n'
		
	return info

func clearChecker():
	descriptionHeader.text = ''
	description.text = ''
	stats.text = ''


func getTextureFromAtlas(texture:Texture2D, pos:int, size:int):
	var atlasTeture = AtlasTexture.new()
	var region = Rect2(pos*size,0,size,size)
	atlasTeture.atlas = texture
	atlasTeture.region = region
	return atlasTeture
	
func drawSpellElement(texture:Texture2D, customMinSize:Vector2):
	var newSpellElement = TextureRect.new()
	newSpellElement.texture = texture
	newSpellElement.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	newSpellElement.custom_minimum_size = customMinSize
	newSpellElement.position.y = (slots[0].custom_minimum_size.y - newSpellElement.custom_minimum_size.y)/2
	$VBoxContainer/FightMenu/MainRows/SubRows/PreviewIMG/spellElements.add_child(newSpellElement)

func _on_node_2d_mouse_entered() -> void:
	mouse = true


func _on_node_2d_mouse_exited() -> void:
	mouse = false
	
func _mouse_exited() -> void:
	currentSelect = -1
	clearChecker()

func resetSpell():
	currentCrystal = 0
	currentSymbol = 0
	currentSigil = 0
	ap = 0
	ad = 0
	turns = 1
	curse = 0
	mTx = 1
	mTy = 1
	sTs = 1
	double = false

func _mouse_entered(extra_arg_0: int) -> void:
	currentSelect = extra_arg_0
	
func AddToList(id:int):
	sTs -= 1
	currentSpellSlotID.append(id)
	$VBoxContainer/FightMenu/MainRows2/nextTurn.text = str(sTs) + " Następna tura"
	
func SubFromList(id:int):
	sTs += 1
	currentSpellSlotID.erase(id)
	$VBoxContainer/FightMenu/MainRows2/nextTurn.text = str(sTs) + " Następna tura"


func _on_next_turn_pressed() -> void:
	for x in currentEnemySlot:
		for y in currentSpellSlotID:
			if x.ID == y:
				x.Attack()
	if double:
		doubleCast.start(0.5)
	else:
		phase = 1
		resetSpell()
		crystalPhase()
		SignalBus.checkTurn.emit()
		currentSpellSlotID.clear()


func _on_double_cast_timeout() -> void:
	doubleCast.stop()
	for x in currentEnemySlot:
		for y in currentSpellSlotID:
			if x.ID == y:
				x.Attack()
	SignalBus.checkTurn.emit()
	currentSpellSlotID.clear()
	phase = 1
	resetSpell()
	crystalPhase()
	SignalBus.checkTurn.emit()
	currentSpellSlotID.clear()
