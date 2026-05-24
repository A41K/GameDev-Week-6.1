extends Control

func _on_server_pressed() -> void:
	if HighLevelNetworkHandler.start_server() != OK:
		return
	
	queue_free()
	var level = load("res://scenes/level_1.tscn").instantiate()
	get_parent().add_child(level)
	
	# Let the server spawn its own player
	var spawner = get_parent().get_node("MultiplayerSpawner")
	if spawner:
		spawner.spawn_player(multiplayer.get_unique_id())

func _on_client_pressed() -> void:
	if HighLevelNetworkHandler.start_client() != OK:
		return
		
	queue_free()
	var level = load("res://scenes/level_1.tscn").instantiate()
	get_parent().add_child(level)
