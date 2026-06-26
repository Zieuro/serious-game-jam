extends CharacterBody2D

var can_move: bool = true
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -200.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("spin") and can_move:
		velocity.y = JUMP_VELOCITY
		sprite.play("on")

	move_and_slide()

func die() -> void:
	can_move = false
	sprite.play("off")
	collision_layer = 0
	collision_mask = 0
	velocity.y = -400
