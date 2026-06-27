extends Control



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Master.fresh_start = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
