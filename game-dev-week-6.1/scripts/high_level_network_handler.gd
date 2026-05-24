extends Node

const HOST: String = "127.0.0.1"
const PORT: int = 42069

var peer: WebSocketMultiplayerPeer

func _clear_peer() -> void:
	if multiplayer.multiplayer_peer == peer:
		multiplayer.multiplayer_peer = null
	if peer:
		peer.close()
		peer = null


func _client_url() -> String:
	return "ws://%s:%d" % [HOST, PORT]

func start_server() -> Error:
	if OS.has_feature("web"):
		push_error("hosting is not supported in the web export; use the exe version for the server")
		return ERR_UNAVAILABLE

	_clear_peer()
	peer = WebSocketMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error != OK:
		print("cannot create server on port ", PORT, ": ", error)
		peer = null
		return error
	multiplayer.multiplayer_peer = peer
	return OK

func start_client() -> Error:
	_clear_peer()
	peer = WebSocketMultiplayerPeer.new()
	var error = peer.create_client(_client_url())
	if error != OK:
		print("cannot create client at ", _client_url(), ": ", error)
		peer = null
		return error
	multiplayer.multiplayer_peer = peer
	return OK
