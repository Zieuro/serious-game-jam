extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -200.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("spin"):
		velocity.y = JUMP_VELOCITY
		sprite.play("on")
	#else:
		#if sprite.animation != "off":
			#sprite.play("off")

	move_and_slide()
