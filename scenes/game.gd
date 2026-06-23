extends Node2D

var speed: float = 22.0


func _process(delta: float) -> void:
	self.global_position = global_position * speed * delta
