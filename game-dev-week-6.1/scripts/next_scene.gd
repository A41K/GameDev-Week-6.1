extends Area2D

const NEXT_SCENE_PATH: String = "res://scenes/level_2.tscn"

static var _players_touching_flags: Dictionary = {}
static var _scene_transitioning: bool = false

func _ready() -> void:
	monitoring = true
	monitorable = true
	set_physics_process(true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	


func _physics_process(_delta: float) -> void:
	if not multiplayer.is_server():
		return

	if _scene_transitioning:
		return

	_refresh_players_inside_from_overlaps()
	_try_advance_scene()


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var authority_id: int = body.get_multiplayer_authority()
	_players_touching_flags[authority_id] = true

	_try_advance_scene()


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var authority_id: int = body.get_multiplayer_authority()
	_players_touching_flags.erase(authority_id)
	


func _refresh_players_inside_from_overlaps() -> void:
	var current_players: Dictionary = {}
	for body in get_overlapping_bodies():
		if body is Node2D and body.is_in_group("player"):
			current_players[body.get_multiplayer_authority()] = true

	for authority_id in current_players.keys():
		_players_touching_flags[authority_id] = true



func _try_advance_scene() -> void:
	if not multiplayer.is_server():
		return

	
	if _scene_transitioning:
		return

	if _players_touching_flags.size() >= 2:
		_scene_transitioning = true
		
		_advance_scene.rpc()


@rpc("authority", "call_local", "reliable")
func _advance_scene() -> void:
	var level_root: Node = get_parent().get_parent()
	if level_root == null:
		
		return

	var scene_root: Node = level_root.get_parent()
	if scene_root == null:
		
		return

	var next_level_scene: PackedScene = load(NEXT_SCENE_PATH)
	if next_level_scene == null:
		
		return

	var next_level: Node = next_level_scene.instantiate()
	scene_root.add_child(next_level)


	_reposition_players_for_next_level(next_level)
	level_root.queue_free()



func _reposition_players_for_next_level(next_level: Node) -> void:
	if next_level == null:

		return

	var players := get_tree().get_nodes_in_group("player")


	for player in players:
		if not (player is Node2D):
			continue

		var authority_id: int = player.get_multiplayer_authority()
		var spawn_name: String = "SpawnPoint" if authority_id == 1 else "SpawnPoint2"
		var spawn_point := next_level.find_child(spawn_name, true, false) as Node2D
		if spawn_point == null:
			spawn_point = next_level.find_child("SpawnPoint", true, false) as Node2D
		if spawn_point == null:
			spawn_point = next_level.find_child("SpawnPoint2", true, false) as Node2D

		if spawn_point:
			if player.has_method("set_respawn_position"):
				player.set_respawn_position(spawn_point.global_position)
			player.global_position = spawn_point.global_position
			if player.has_method("respawn"):
				player.respawn()
