extends CharacterBody2D

var speed = 200
var gravity = 700
var jump_velocity = -260
var jump_count = 0
var max_jump = 2
var dash_speed = 4*speed
var dash_duration = 0.2
var dash_cooldown = 1.0
var is_dashing = false
var dash_time = 0.0
var dash_direction = Vector2.ZERO
var can_dash = true

@onready var body: AnimatedSprite2D = $Body

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_dashing:
		perform_dash(delta)
	else:
		handle_gravity(delta)
		handle_jump()
		handle_movement_and_animation()
		move_and_slide()
	
	if Input.is_action_just_pressed("dash") and can_dash:
		start_dash()

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

func start_dash() -> void:
	is_dashing = true
	dash_time = 0.0
	dash_direction = Vector2.ZERO
	
	if velocity.x !=0:
		dash_direction = velocity.normalized()
	else:
		dash_direction = Vector2.RIGHT if body.flip_h == false else Vector2.LEFT
	body.play("shift")
	velocity.x = dash_direction.x * dash_speed
	can_dash = false

func perform_dash(delta: float) -> void:
	dash_time += delta
	if dash_time < dash_duration:
		move_and_slide()
	else:
		is_dashing = false
		velocity.x = 0
		await get_tree().create_timer(dash_cooldown).timeout
		can_dash = true
