extends StaticBody

var health = 50

func die():
	queue_free()

func bullet_hit(damage):
	
	health -= damage
	print(":o")
	print(damage)
	if ($AnimationPlayer.is_playing()):
		$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	if health == 0:
		die()
		
	
#	$MeshInstance.material_override.albedo_color = Color(255,0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
