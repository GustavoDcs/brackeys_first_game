extends CharacterBody2D

const MAX_WALK_SPEED = 100.0
const WALK_ACCELERATION = 300.0

const MAX_RUN_SPEED = 200.0
const RUN_ACCELERATION = 100.0

const DECELERATION = 1000.0

const JUMP_VELOCITY = -300.0
const FAST_FALL_SPEED = 1000.0

const DASH_DURATION = 0.2  
const DASH_SPEED = 200.0   

var is_dead = false
var is_running = false
var is_dashing = false 

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dash_timer = 0.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	GameManager.update_speed_label(velocity.x)
	
	var direction = Input.get_axis("control_left", "control_right")
	var target_velocity_x = direction * MAX_WALK_SPEED

	# Check if dash button is pressed and player is moving
	is_running = Input.is_action_pressed("control_sprint") and direction != 0
	if is_running:
		target_velocity_x = direction * MAX_RUN_SPEED  # Apply higher speed limit for dashing

	# Accelerate or decelerate towards the target velocity
	if velocity.x < target_velocity_x:
		velocity.x = min(velocity.x + (RUN_ACCELERATION if is_running else WALK_ACCELERATION) * delta, target_velocity_x)
	elif velocity.x > target_velocity_x:
		velocity.x = max(velocity.x - (RUN_ACCELERATION if is_running else WALK_ACCELERATION) * delta, target_velocity_x)

	# Handle dashing
	if Input.is_action_just_pressed("control_dash") and not is_dashing and velocity.x != 0:
		print("Dashing")
		is_dashing = true
		dash_timer = DASH_DURATION
		velocity.x += DASH_SPEED * direction

	if is_dashing:
		if dash_timer > 0:
			dash_timer -= delta
		else:
			is_dashing = false
			velocity.x = 0

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_pressed("control_down"):
			velocity.y += FAST_FALL_SPEED * delta

	# Handle jump.
	if Input.is_action_just_pressed("control_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Flip the sprite based on direction
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if not is_dead:
		if is_running:
			animated_sprite.play("run")
		elif is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")
		elif velocity.y > 0:
			animated_sprite.play("falling")
		elif velocity.y < 0:
			animated_sprite.play("jump")
	else:
		animated_sprite.play("die")

	# Perform the movement
	move_and_slide()
