extends Control

@onready var server_button: Button = $CenterContainer/VBoxContainer/MarginContainer/ButtonsVBox/Server
@onready var client_button: Button = $CenterContainer/VBoxContainer/MarginContainer/ButtonsVBox/Client

func _ready() -> void:
	if OS.has_feature("web"):
		server_button.disabled = true
		server_button.text = "HOST GAME (EXE ONLY)"

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
