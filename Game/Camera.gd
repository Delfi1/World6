extends CharacterBody3D


const SPEED = 5.0

@onready var Neck = $Neck

@onready var Camera = $Neck/GlobalCamera


func IsCaptured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	if not IsCaptured():
		return
	
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
