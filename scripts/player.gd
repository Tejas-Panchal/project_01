extends CharacterBody2D

var speed = 100
var gravity = 500
var jump_velocity = -260
var jump_count = 0
var max_jump = 2

@onready var body: AnimatedSprite2D = $Body

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

var temp = 0
func _physics_process(delta: float) -> void:
	# add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0
	
	# handle wall jump
	if is_on_wall():
		jump_count = 1
	
	# handle jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			body.play("jump")
			jump_count = 1
		elif jump_count < max_jump:
			velocity.y = jump_velocity + 50
			body.play("jump")
			jump_count += 1
	
	if velocity.y > 0:
		body.play("fall")		
	
	if Input.is_action_just_released("jump"):
		if jump_count < max_jump:
			velocity.y = 0
	
	# get direction: (-1, 0, 1)
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
	
	move_and_slide()
