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


signal ammo_changed

var object_to_interact

var current_gun : Gun
var guns = []

func _ready():
	add_gun("res://guns/Gun.tscn")

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
	
	gun.transform = $Rig/GunPosition.transform
	current_gun = gun
	$Rig.add_child(gun)

func _input(event):
	
	# weapon switch keyboard
	var input_as_int = int(event.as_text())
	if input_as_int > 0 and input_as_int< 10 :
		switch_gun(input_as_int - 1)

	if event.is_action_pressed("interact"):
		add_gun("res://guns/Gun2.tscn")
#		switch_gun("res://guns/Gun2.tscn")
		
#		if object_to_interact != null:
#			object_to_interact.interact()
	if event.is_action_pressed("reload"):
		current_gun.reload()

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
	

func _process(delta):

	# TIR
	if Input.is_action_pressed("tir") :
		current_gun.shoot()

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
	
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd, [], 8)
	
	if not intersection.empty() and not camera_rotating:
		var pos = intersection.position
#		print(intersection.collider.name)
		$Rig.look_at(Vector3(pos.x, translation.y, pos.z), Vector3.UP)
