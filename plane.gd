extends CharacterBody3D

var print_delay = 1
var next_print = 0
const SPEED_MPS = 500
const FLAP_NEUTRAL = PI/2
const FLAP_UP = -PI/4
const FLAP_DOWN = PI/4

func _physics_process(delta):

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var roll = -input_dir[0]
	var pitch = input_dir[1]
	var forward = -transform.basis.z
	
	var z_axis_rotation = rotation.z # -PI..PI
	var z_rotation_normalized = z_axis_rotation / PI # -1..1
	if z_rotation_normalized > 0.5:
		z_rotation_normalized = 1 - z_rotation_normalized
	elif z_rotation_normalized < -0.5:
		z_rotation_normalized = -1 - z_rotation_normalized
	
	# give a little yaw rotation based on current z rotation
	var yaw_drift = z_rotation_normalized * PI * .33 * delta
	
	if next_print <= 0:
		print("roll ", roll,
			  "   pitch ", pitch,
			  "   forward: ", forward)
		print("rotation: ", rotation)
		print("z_rotation_normalized: ", z_rotation_normalized)
		next_print = print_delay
	else:
		next_print -= delta

	rotate(transform.basis.z, roll * delta)
	rotate(transform.basis.x, pitch  * delta)
	rotate_y(yaw_drift)

	# animate the flaps for fun
	$flap_axis_left.rotation.x = FLAP_NEUTRAL
	$flap_axis_right.rotation.x = FLAP_NEUTRAL

	if roll < 0:
		$flap_axis_left.rotation.x = FLAP_NEUTRAL + FLAP_DOWN
		$flap_axis_right.rotation.x = FLAP_NEUTRAL + FLAP_UP
	elif roll > 0:
		$flap_axis_left.rotation.x = FLAP_NEUTRAL + FLAP_UP
		$flap_axis_right.rotation.x = FLAP_NEUTRAL + FLAP_DOWN
	
	if pitch > 0:
		$flap_axis_left.rotation.x = FLAP_NEUTRAL + FLAP_UP
		$flap_axis_right.rotation.x = FLAP_NEUTRAL + FLAP_UP
	elif pitch < 0:
		$flap_axis_left.rotation.x = FLAP_NEUTRAL + FLAP_DOWN
		$flap_axis_right.rotation.x = FLAP_NEUTRAL + FLAP_DOWN
	
	
	velocity = forward * SPEED_MPS * delta
	move_and_slide()
