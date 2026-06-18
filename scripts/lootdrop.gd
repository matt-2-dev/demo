extends Node2D

@export var loot_type: String = "ammo"   # "ammo", "health", "points"
@export var amount: int = 1
@export var spawn_points: Array[Node2D]

var loot_types = ["ammo", "health", "points"]
var gm

func _ready():
	gm = get_tree().get_root().get_node("Node2D")
func _lootdrop_enter(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("is in player group")
		var loot_text = $"loot-label-holder/loot-text"
		var loot = gm.get_loot(loot_text)
		if loot.item == "Ammo":
			gm.give_ammo(loot.amount)
			print("gave ammo")
