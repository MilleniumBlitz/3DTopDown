extends Spatial

class_name Gun

var bullet = preload("res://guns/Bullet.tscn")

export(float) var fire_rate = 1
export(int) var mag_size = 20
onready var shooting_point = $ShootPosition
var ammo = mag_size

func _ready():
	$ShootTimer.wait_time = fire_rate

func shoot():
	if ammo == 0:
		reload()
	else:
		
		if $ShootTimer.is_stopped() and $ReloadTimer.is_stopped():
			ammo -= 1

			# Sound
			$ShootSound.play()
			$ShootTimer.start()
			
			# Spawn a bullet
			var new_bullet = bullet.instance()
			new_bullet.global_transform = shooting_point.global_transform
			get_tree().get_root().add_child(new_bullet)

func reload():
	if ammo != mag_size:
		$ReloadTimer.start()
		$ReloadSound.play()
		ammo = mag_size
