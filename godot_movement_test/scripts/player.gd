extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0
var jump = 0
var jump_buffer:bool = false
var jump_buffer_time:float = .1

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
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():	
			jumping()
		else:
			#sets the buffer for jumping
			jump_buffer = true
			get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)
		
	#allows double jump
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and jump < 1:	
		jumping()
		#fix this or smthing so it lets you jump even ater you kinda left the ground
		
	#reset double jump
	if is_on_floor() and jump != 0:
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
