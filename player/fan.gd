extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -200.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("spin"):
		velocity.y = JUMP_VELOCITY

	move_and_slide()
