extends Node2D

@export var loot_type: String = "Ammo"
@export var amount: int = 1
@export var player: CharacterBody2D
var loot_spawner
var gm
var debugUI
var gameUI

func _ready():
	gm = get_tree().get_root().get_node("Node2D")
	debugUI = get_tree().get_root().get_node("Node2D/DebugUI")
	gameUI = get_tree().get_root().get_node("Node2D/GameUI")
	player = get_tree().get_first_node_in_group("player")
	loot_spawner = get_tree().get_root().get_node("Node2D/LootSpawner")

func _lootdrop_enter(area: Area2D) -> void:
	if area.is_in_group("player"):
		var loot_text = $"loot-label-holder/loot-text"
		var loot = gm.get_loot(loot_text)
		if loot.item == "Health":
			if player.health < 5:
				var give = clamp(player.health + loot.amount, 0, 5)
				player.health = give
				gameUI.get_node("health-bar").value = player.health
				loot_spawner.current_loot -= 1
				queue_free()
