extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 42069

var peer: ENetMultiplayerPeer

func start_server() -> Error:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error != OK:
		print("cannot create server: ", error)
		return error
	multiplayer.multiplayer_peer = peer
	return OK

func start_client() -> Error:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(IP_ADDRESS, PORT)
	if error != OK:
		print("cannot create client: ", error)
		return error
	multiplayer.multiplayer_peer = peer
	return OK
