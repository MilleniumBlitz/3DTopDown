extends Spatial

onready var player = $Player
onready var debugUI = $DebugUI

func _ready():
	player.connect("ammo_changed", debugUI, "ammo_changed")
