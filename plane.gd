extends CharacterBody3D

var print_delay = 1
var next_print = 0

func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if next_print <= 0:
		print(input_dir)
		next_print = print_delay
	else:
		next_print -= delta
	
	var roll = -input_dir[0]
	var pitch = input_dir[1]
	
	rotate(transform.basis.z, roll * delta)
	rotate(transform.basis.x, pitch  * delta)