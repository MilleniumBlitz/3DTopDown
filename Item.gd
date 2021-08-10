extends Spatial

var player

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
