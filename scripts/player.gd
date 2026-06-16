extends CharacterBody2D

var speed_player: float = 500.0
var jump_player: float = -450.0
var health: int = 5

@export var bullet_scene: PackedScene
@export var player: Node
@export var bullet_spawn: Marker2D
@export var pivot: Node2D

func _ready() -> void:
	add_to_group("player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction: Vector2 = Vector2(0.0,0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_left"):
		pivot.scale.x = -1
		bullet_spawn.rotation = PI
	if Input.is_action_just_pressed("ui_right"):
		pivot.scale.x = 1
		bullet_spawn.rotation = rad_to_deg(0)
	if direction.x:
		velocity.x = direction.x * speed_player
	else:
		velocity.x = move_toward(velocity.x, 0, speed_player)
	move_and_slide()
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_player
	if Input.is_action_just_pressed("ui_shoot"):
		spawn_bullet()
func spawn_bullet() -> void:
	var b = bullet_scene.instantiate()
	b.rotation = bullet_spawn.rotation
	b.global_position = bullet_spawn.global_position
	add_sibling(b)


func _player_damage(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		health -=1
	elif health == 0:
		get_tree().reload_current_scene()
