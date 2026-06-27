extends Node

@onready var my_balloon = load("res://dialogue/balloon.tscn")
@onready var credits: Timer = $Credits


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var balloon: Node = DialogueManager.show_dialogue_balloon_scene(my_balloon, load("res://dialogue/win.dialogue"), "start")
	await balloon.tree_exited
	credits.start()

func _on_credits_timeout() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
