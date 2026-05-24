extends Area2D

@export var barrier_node: Node2D

var players_on_plate: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if not barrier_node:
		var root = get_tree().current_scene
		barrier_node = root.get_node_or_null("Barrier/Barrier")
		if not barrier_node:
			barrier_node = get_node_or_null("../../Barrier/Barrier")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		players_on_plate += 1
		_update_barrier()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		players_on_plate -= 1
		_update_barrier()

func _update_barrier() -> void:
	if barrier_node:
		if players_on_plate > 0:
			barrier_node.hide()
			barrier_node.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
			if barrier_node is CollisionObject2D:
				barrier_node.set_deferred("collision_layer", 0)
				barrier_node.set_deferred("collision_mask", 0)
		else:
			# Reappear
			barrier_node.show()
			barrier_node.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
			if barrier_node is CollisionObject2D:
				barrier_node.set_deferred("collision_layer", 1)  
				barrier_node.set_deferred("collision_mask", 1)
