extends Spatial

onready var item = preload("res://items/Item.tscn")

func interact():
	
	$AnimationPlayer.play("Cube001Action")
	
	# Spanw item
	var loot_item = item.instance()
	loot_item.scene_to_show = load("res://guns/models/MP5.tscn")
	add_child(loot_item)

func _on_Area_body_entered(body):
	if body is Player:
		body.object_to_interact = self
