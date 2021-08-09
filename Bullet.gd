extends Spatial

var move_direction
var speed = 30

func _process(delta):
	
	# Movement of the bullet
	var forward_direction = -global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)

func _on_Area_body_entered(body):
	
	# When the bullet collide with a body
	queue_free()
	
	if body.has_method("bullet_hit"):
		body.bullet_hit(5)
