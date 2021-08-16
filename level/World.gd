extends Spatial

onready var player = $Player
#onready var debugUI = $DebugUI
#onready var camera = $Camera

func _ready():
	player.connect("inventory_add", $Inventory, "add_item")
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	player.connect("ammo_changed", debugUI, "ammo_changed")
#	debugUI.add_stat("Velocity", player, "velocity", false)
#	player.conn
