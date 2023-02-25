extends CharacterBody3D


const SPEED = 5.0

@onready var Neck = $Neck

@onready var Camera = $Neck/GlobalCamera


func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if IsCaptured():
		if event is InputEventMouseMotion:
			Neck.rotate_y(-event.relative.x * 0.005)
			Camera.rotate_x(-event.relative.y * 0.005)
			Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-60), deg_to_rad(90))

func IsCaptured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (Neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var input_y = Input.get_action_strength("Space") - Input.get_action_strength("Shift")

	if input_y:
		velocity.y = input_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
