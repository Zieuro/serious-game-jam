extends Node

@onready var bg: Parallax2D = %Office
@onready var player: CharacterBody2D = %FAN
@onready var timer: Timer = $Timer
@onready var game: Timer = $Game
@onready var win: Timer = $Win
@onready var death: Timer = $Death
@onready var start_message: PanelContainer = $PanelContainer
@onready var my_balloon = load("res://dialogue/balloon.tscn")
@onready var fan_sfx: AudioStreamPlayer = $Fan

var bg_stop: Vector2 = Vector2(0,0)
var bg_start: Vector2 = Vector2(-90,0)

var paused: bool = true
var can_unpause: bool = false

func _ready() -> void:
	fan_sfx.stream_paused = true
	bg.autoscroll = bg_stop
	start_message.visible = true
	
	if Master.fresh_start:
		var start_dialogue: Node = DialogueManager.show_dialogue_balloon_scene(my_balloon, load("res://dialogue/start.dialogue"), "start")
		await start_dialogue.tree_exited
		Master.fresh_start = false
	can_unpause = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spin") and paused and can_unpause:
		paused = false
		timer.start()
		game.start()
		bg.autoscroll = bg_start
		player.can_move = true
		fan_sfx.stream_paused = false
		start_message.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	player.die()
	bg.autoscroll = bg_stop

func _on_death_timeout() -> void:
	get_tree().change_scene_to_file("res://death.tscn")


func _on_game_timeout() -> void:
	bg.autoscroll = bg_stop
	timer.stop()
	player.won = true
	win.start()


func _on_win_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/boss_office.tscn")
