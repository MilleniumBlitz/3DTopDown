extends Spatial

export(PackedScene) var scene_to_show = null setget set_item_to_show
var player

func _ready():
	if scene_to_show:
		var item_display = scene_to_show.instance()
		add_child(item_display)
	
func set_item_to_show(value):
	if value:
		scene_to_show = value
		var item_display = scene_to_show.instance()
		add_child(item_display)

func interact():
	# The player pick the item
	player.add_gun("res://guns/models/MP5.tscn")
	queue_free()

func _on_Area_body_entered(body):
	if body is Player:
		player = body
		body.object_to_interact = self
		
func _on_Area_body_exited(body):
	if body is Player:
		body.object_to_interact = null
