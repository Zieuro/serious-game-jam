extends Node

@onready var my_balloon = load("res://dialogue/balloon.tscn")
@onready var credits: Timer = $Credits


func _ready() -> void:
	DialogueManager.show_dialogue_balloon_scene(my_balloon, load("res://dialogue/win.dialogue"), "start")


func _on_credits_timeout() -> void:
	print("roll credits")
