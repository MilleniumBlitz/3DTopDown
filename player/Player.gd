extends KinematicBody

class_name Player

onready var camera = $Spatial/Camera
var mouse_sens = 0.3
var camera_anglev=0
var camera_rotating = false

var velocity := Vector3()
var speed = 10
var max_speed = 10

var space_state
var rayOrigin
var rayEnd

var gravity = -100

signal ammo_changed

var object_to_interact

var current_gun : Gun
var guns = []

func _ready():
	add_gun("res://guns/models/BasicGun.tscn")

func switch_gun(number):
	
	if guns.size() > number:
		
		if current_gun:
			current_gun.get_parent().remove_child(current_gun)
		
		# Charge la nouvelle arme
		var new_gun = guns[number]
		spawn_gun(new_gun)

func add_gun(gun_scene):
	
	# Remplace l'arme existante
	if current_gun:
		current_gun.get_parent().remove_child(current_gun)
	
	var new_gun = load(gun_scene).instance()
	spawn_gun(new_gun)
	guns.append(new_gun)
	
func spawn_gun(gun):
	
	gun.transform.origin = $Rig/GunPosition.transform.origin
	current_gun = gun
	$Rig.add_child(gun)

func _input(event):
	
	# weapon switch keyboard
	var input_as_int = int(event.as_text())
	if input_as_int > 0 and input_as_int< 10 :
		switch_gun(input_as_int - 1)

	if event.is_action_pressed("interact"):
		if object_to_interact != null:
			object_to_interact.interact()
			
	if event.is_action_pressed("reload"):
		current_gun.reload()

	if event.is_action_pressed("rotate_camera"):
		camera_rotating = true
			
	if event.is_action_released("rotate_camera"):
		camera_rotating = false
		
	if event is InputEventMouseMotion:
		if camera_rotating:
			$Spatial.rotate_y(deg2rad(-event.relative.x * mouse_sens))
			var changev =- event.relative.y * mouse_sens
			if camera_anglev + changev >- 50 and camera_anglev + changev < 50:
				camera_anglev += changev
				
func get_direction() -> Vector3:
	var direction = Vector3()
	direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")		
	return direction
				
func _process(delta):

	space_state = get_world().direct_space_state

	# TIR
	if Input.is_action_pressed("tir") :
		current_gun.shoot()

	# MOUVEMENT
	var direction = get_direction()	
	velocity = ((-$Spatial.global_transform.basis.z * direction.z) + ($Spatial.global_transform.basis.x * direction.x)).normalized() * speed
	velocity.y = 0
	
	velocity = move_and_slide(velocity, Vector3.UP)

	# ROTATION PERSONNAGE SOURIS
	player_rotation()
	
func player_rotation():
	var mouse_position = get_viewport().get_mouse_position()
	
	rayOrigin = camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd, [], 8)
	
	if not intersection.empty() and not camera_rotating:
		var pos = intersection.position
		$Rig.look_at(Vector3(pos.x, translation.y, pos.z), Vector3.UP)
