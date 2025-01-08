extends CharacterBody2D

var speed = 100
var gravity = 700
var jump_velocity = -260
var jump_count = 0
var max_jump = 2

@onready var body: AnimatedSprite2D = $Body

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_jump()
	handle_movement_and_animation()
	move_and_slide()

func handle_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

func handle_jump() -> void:
	if is_on_wall():
		jump_count = 1
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			body.play("jump")
			jump_count = 1
		elif jump_count < max_jump:
			velocity.y = jump_velocity
			body.play("jump")
			jump_count += 1
	
	if velocity.y > 0:
		body.play("fall")
	
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y = 0

func handle_movement_and_animation() -> void:
	var direction = Input.get_axis("left", "right")
	
	# movement
	if direction:
		velocity.x = (direction * speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# facing direction
	if direction == -1:
		body.flip_h = true
	elif direction == 1:
		body.flip_h = false
	
	# play animation
	if is_on_floor():
		if direction == 0:
			body.play("idle")
		elif velocity.y == 0:
			body.play("run")
