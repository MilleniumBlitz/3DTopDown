extends StaticBody

var health = 50

func die():
	queue_free()

func bullet_hit(damage):
	
	health -= damage
	
	if ($AnimationPlayer.is_playing()):
		$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	if health == 0:
		die()
