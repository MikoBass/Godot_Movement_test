extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0
var jump = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():	
		velocity.y = JUMP_VELOCITY
		jump += 1
	#allows double jump
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and jump < 1:	
		velocity.y = JUMP_VELOCITY
		jump += 1
		#fix this or smthing so it lets you jump even ater you kinda left the ground
	#reset double jump
	if is_on_floor() and jump != 0:
		print("ass")
		jump = 0
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if velocity.x < SPEED && velocity.x > -SPEED:
			velocity.x += direction * 20
			print(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, 15)

	move_and_slide()
