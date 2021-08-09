extends KinematicBody

class_name Player

onready var camera = $Spatial/Camera
var mouse_sens = 0.3
var camera_anglev=0
var camera_rotating = false

var velocity := Vector3()
var speed = 500

var space_state
var rayOrigin
var rayEnd

var ammo = 12
var bullet = preload("res://guns/Bullet.tscn")
signal ammo_changed

var object_to_interact
var gun 

func _ready():
	switch_gun("res://guns/Gun.tscn")

func switch_gun(gun_scene):
	
	# Remplace l'arme existante
	if gun:
		gun.queue_free()
		
	# Charge la nouvelle arme
	var new_gun = load(gun_scene).instance()
	new_gun.transform = $Rig/GunPosition.transform
	gun = new_gun
	$ShootTimer.wait_time = new_gun.fire_rate
	$Rig.add_child(new_gun)

func _input(event):

	if event.is_action_pressed("interact"):
		switch_gun("res://Gun2.tscn")
		
#		if object_to_interact != null:
#			object_to_interact.interact()
		

	if event.is_action_pressed("rotate_camera"):
		camera_rotating = true
			
	if event.is_action_released("rotate_camera"):
		camera_rotating = false
		
	if event is InputEventMouseMotion:
		if camera_rotating:
			$Spatial.rotate_y(deg2rad(-event.relative.x*mouse_sens))
			var changev =- event.relative.y*mouse_sens
			if camera_anglev + changev >- 50 and camera_anglev +changev < 50:
				camera_anglev += changev
#				$Spatial.rotate_x(deg2rad(changev))
func reload():
	$ReloadTimer.start()
	$ReloadSound.play()
	ammo = 12
	emit_signal("ammo_changed", ammo)
	
func shoot():
	
	# If no ammo left, reload
	if ammo == 0:
			reload()
	else:
		ammo -= 1
		emit_signal("ammo_changed", ammo)
		
		# Sound
		$ShootSound.play()
		$ShootTimer.start()
		
		# Spawn a bullet
		var new_bullet = bullet.instance()
		new_bullet.global_transform = gun.shooting_point.global_transform
		get_tree().get_root().add_child(new_bullet)
		
#		var result = space_state.intersect_ray($Rig/ShootPosition.global_transform.origin, Vector3(mousePos3D.x, translation.y, mousePos3D.z))
#		if result:
#			var hit_body = result.collider
#			var DAMAGE = 5
#			if hit_body.has_method("bullet_hit"):
#				hit_body.bullet_hit(DAMAGE)
#			print("toto : ", result.collider.name)
#			print("ouch ", result.position)
		

func _process(delta):

	# TIR
	if Input.is_action_pressed("tir") and $ShootTimer.is_stopped() and $ReloadTimer.is_stopped():
		shoot()

	space_state = get_world().direct_space_state
	
	# MOUVEMENT
	var move_x =  Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	var move_z =  Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	
	var velocity = Vector3(move_x, -10, move_z)
	velocity = move_and_slide(velocity * speed * delta, Vector3.UP)

	# ROTATION PERSONNAGE
	var mouse_position = get_viewport().get_mouse_position()
	
	rayOrigin = camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd, [self])
	
	if not intersection.empty() and not camera_rotating:
		var pos = intersection.position
#		print(intersection.collider.name)
		$Rig.look_at(Vector3(pos.x, translation.y, pos.z), Vector3.UP)

	
	
	
