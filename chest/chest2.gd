extends Spatial
	
func interact():
#	print("interacted")
	$AnimationPlayer.play("Cube001Action")

func _on_Area_body_entered(body):
	
	if body is Player:
		body.object_to_interact = self
	pass # Replace with function body.
