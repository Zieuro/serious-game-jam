class_name Obstacle extends CharacterBody2D

signal touched

var speed: Vector2 = Vector2(-169,0)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(speed * delta)
	if collision:
		touched.emit()


func _on_area_2d_area_entered(area: Area2D) -> void:
	touched.emit()
