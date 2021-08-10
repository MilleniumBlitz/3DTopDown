extends Spatial

func interact():
	print(":o")
	$AnimationPlayer.play("Cube001Action")

func _on_Area_body_entered(body):
	if body is Player:
		body.object_to_interact = self
