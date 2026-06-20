extends Area2D
var speed: float = 800.00
var direction = 1
func _physics_process(delta):
	move_local_x(speed * delta)
