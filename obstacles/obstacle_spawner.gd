extends Node2D

@export var obstacle_list: Array[PackedScene]
@onready var fan: CharacterBody2D = %FAN
@onready var office: Parallax2D = %Office

func pick_obstacle():
	var randOb = obstacle_list.pick_random()
	var obstacle = randOb.instantiate()
	obstacle.position = _get_rand_pos()
	self.add_child(obstacle)
	obstacle.touched.connect(_on_touch)
	
	if obstacle.position.x < 0:
		obstacle.queue_free()

func _get_rand_pos() -> Vector2:
	var obstacle_pos: Vector2
	obstacle_pos.x = 500
	
	var zone = randi_range(1, 3)
	match zone:
		1:
			obstacle_pos.y = randf_range(30.0, 60.0)
		2:
			obstacle_pos.y = randf_range(60.0, 150.0)
		3:
			obstacle_pos.y = randf_range(140.0, 160.0)
	
	return obstacle_pos

func _on_timer_timeout() -> void:
	pick_obstacle()

func _on_touch() -> void:
	fan.die()
	office.autoscroll = Vector2(0,0)
