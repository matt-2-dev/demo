extends Area2D
var speed: float = 800.00
var direction = 1
func _physics_process(delta):
	move_local_x(speed * delta)
func _touch(area: Area2D) -> void:
	print("BULLET HIT at ", Time.get_ticks_msec(), "ms | hit ", area.name)
