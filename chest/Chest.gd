extends Spatial
	
func interact():
	print("interacted")

func _on_Area_body_entered(body):
	
	if body is Player:
		body.object_to_interact = self
	print("interacted")
	pass # Replace with function body.
