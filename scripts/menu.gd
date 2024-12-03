extends Node2D

@onready var chooseClass = $ChooseClass

var CClass:int = 0


func _on_choose_pressed() -> void:
	Gfad.CLASS = CClass
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	


func _on_left_arrow_pressed() -> void:
	if CClass >= 1:
		CClass -= 1
	else:
		CClass = 3
	chooseClass.changeClass(CClass)

func _on_right_arrow_pressed() -> void:
	if CClass < 3:
		CClass += 1
	else:
		CClass = 0
	chooseClass.changeClass(CClass)


func _on_choose2_pressed() -> void:
	Gfad.CLASS = CClass
	get_tree().change_scene_to_file("res://scenes/combat_system.tscn")
