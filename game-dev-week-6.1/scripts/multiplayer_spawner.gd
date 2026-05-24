extends MultiplayerSpawner

@export var network_player: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	
func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	
	var player: Node = network_player.instantiate()
	player.name = str(id)
	
	var spawn_points = get_tree().get_nodes_in_group("SpawnPoint")
	if spawn_points.size() > 0:
		spawn_points.sort_custom(func(a, b): return str(a.name) < str(b.name))
		var spawn_index: int = max(id, 1) - 1
		var spawn_point: Node2D = spawn_points[spawn_index % spawn_points.size()]
		player.global_position = spawn_point.global_position
		if player.has_method("set_respawn_position"):
			player.set_respawn_position(spawn_point.global_position)
	
	get_node(spawn_path).call_deferred("add_child", player)
