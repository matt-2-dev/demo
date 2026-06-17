extends Area2D
var speed: float = 800.00
var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(speed * delta)


func _touch(body: Node2D) -> void:
	print("bullet touched:",body.name)
	print("is body a enemy?",body.is_in_group("enemy"))
	if body.is_in_group("enemy"):
		queue_free()
