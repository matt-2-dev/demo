extends Node2D
# cooldown export vars
@export var shoot_cooldown:Timer
@export var point_per_kill_cooldown: int
@export var shoot_cooldown_price: int
@export var point_per_kill_price: int
# actual vars
var shoot_cooldown_base_price = 5
var point_per_kill_base_price = 7
var Player
# functions
func _ready():
	Player = get_tree().get_first_node_in_group("player")
func _upgrade_shoot_cooldown():
	if (Player.points >= shoot_cooldown_price):
		print("can upgrade")
	else:
		print("nope")
func _upgrade_points_per_kill_cooldown():
	if (Player.points >= point_per_kill_price):
		print("can upgrade")
	else:
		print("nope")
