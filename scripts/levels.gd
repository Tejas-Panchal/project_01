extends Node2D




func _on_level_01_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_level_02_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test.tscn")
