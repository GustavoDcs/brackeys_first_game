extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const FAST_FALL_SPEED = 1000.0
const DASH_SPEED = 200.0
const DASH_DURATION = 0.1

var is_dead = false
var is_dashing = false
var dash_timer = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
		#Get the input direction: -1, 0, 1
	var direction = Input.get_axis("control_left", "control_right")
	
	# Handle dash
	if Input.is_action_just_pressed("control_dash") and not is_dashing and velocity.x != 0:
		print("Dashei")
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
		print("jumping")

	#Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if not is_dead: 
		if is_dashing:
			animated_sprite.play("dash")
		elif is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		elif velocity.y > 0: 
			animated_sprite.play("falling")
		elif velocity.y < 0: 
			animated_sprite.play("jump")
	else:
		animated_sprite.play("die")


	# Handle movement
	if direction and not is_dead and not is_dashing:
		velocity.x = direction * SPEED
	elif not is_dashing:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
