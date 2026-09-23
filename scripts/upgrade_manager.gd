extends CanvasLayer

# cooldown export vars
@export var shoot_cooldown:Timer
@export var point_per_kill_cooldown: int
@export var shoot_cooldown_price: int
@export var point_per_kill_price: int
# actual vars
var shoot_cooldown_base_price = 5
var point_per_kill_base_price = 7
var player

func _ready():
	player = get_node("../CharacterBody2D")
	#ammo = player.ammo
	#reserve_ammo = player.reserve_ammo
	#points = player.points
	#health = player.health
# upgrade shoot cooldown button
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_exit"):
		visible = false
func _upgrade_shoot_cooldown() -> void:
	print("button for upgrade shoot cooldown is pressed :0")
func _upgrade_point_per_kill() -> void:
	print("button for upgrade point per kill is pressed :0")
func _exit() -> void:
	visible = false
