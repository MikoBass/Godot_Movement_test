extends CharacterBody2D


var SPEED = 160.0
var JUMP_VELOCITY = -350.0
var jump = 0
var jump_buffer:bool = false
var jump_buffer_time:float = .1
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2
	else:
		#jumps you if you hit the jump before hit the gound
		if jump_buffer:
			jumping()
			jump_buffer = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():	
			jumping()
		else:
			#sets the buffer for jumping
			jump_buffer = true
			get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)
		
	#allows double jump
	if Input.is_action_just_pressed("jump") and not is_on_floor() and jump < 1:	
		jumping()
		
	#reset double jump
	if is_on_floor() and jump != 0:
		jump = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var direction := Input.get_axis("move_left", "move_right")
	
	if direction < 0:
		animated_sprite.flip_h = true
	elif direction > 0:
		animated_sprite.flip_h = false
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
			if Input.is_action_pressed("crouch"):
				animated_sprite.play("crouch")
		else:
			if Input.is_action_pressed("crouch"):
				animated_sprite.play("crouch")
			else:
				animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
		
		
	if direction:
		if velocity.x < SPEED && velocity.x > -SPEED:
			if Input.is_action_pressed("crouch") && direction > 0:
				velocity.x = move_toward(velocity.x, SPEED/2, 5)
			elif Input.is_action_pressed("crouch") && direction < 0:
				velocity.x = move_toward(velocity.x, -SPEED/2, 5)
			else:
				velocity.x += direction * 15
				if velocity.x > SPEED:
					velocity.x = SPEED 
				elif velocity.x < -SPEED:
					velocity.x = -SPEED 
					
				print(velocity.x)
				print(direction)
	else:
		direction = 0
		velocity.x = move_toward(velocity.x, 0, 15)
	move_and_slide()
	#do reset buttons here i dont have tme
	#if InputEventAction.:
		#reset()
#makes ya jump
func jumping() -> void:
	velocity.y = JUMP_VELOCITY
	jump += 1
func on_jump_buffer_timeout()->void:
	jump_buffer = false
	
func reset():
	get_tree().reload_current_scene()
