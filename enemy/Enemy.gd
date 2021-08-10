extends KinematicBody

var health = 50

var player = null

var velocity
var speed = 400

func _process(delta):
	if player:
		velocity = global_transform.origin.direction_to(player.global_transform.origin) * speed * delta
		move_and_slide(velocity)

func bullet_hit(damage):
	
	health -= damage

	if ($AnimationPlayer.is_playing()):
		$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	
	if health == 0:
		die()

func die():
	queue_free()

func _on_Area_body_entered(body):
	
	# Player enter detection area
	if body is Player:
		player = body
func _on_Area_body_exited(body):
	
	# Player leave detection area
	if body is Player:
		player = null
