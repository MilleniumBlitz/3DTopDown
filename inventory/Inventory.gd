extends Control

func _ready():
	
	for i in range(20):
		var btn = load("res://inventory/InventorySpace.tscn").instance()
#		$VSplitContainer/HSplitContainer/GridContainer.add_child(btn)

func add_item(item):
	print(":oui")
	var btn = load("res://inventory/InventorySpace.tscn").instance()
	$HSplitContainer/ScrollContainer/GridContainer.add_child(btn)

func _input(event):
	if event.is_action_pressed("inventory"):
		visible = not visible
		get_tree().paused = visible
