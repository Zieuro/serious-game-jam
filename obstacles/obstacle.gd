extends CharacterBody2D

var speed: Vector2 = Vector2(-169,0)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(speed * delta)
	if collision:
		print("I hit something")
	
