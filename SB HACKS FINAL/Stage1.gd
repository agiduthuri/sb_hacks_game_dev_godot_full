extends Node2D

func _ready():
	var p = get_tree().get_root().find_node("Player", true, false)
	p.connect("game_over", self, "switch_scenes")

func switch_scenes():
	get_tree().change_scene("res://main_menu.tscn")
