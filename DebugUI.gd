extends Node2D

func ammo_changed(value):
	$Ammo.text = "Ammo : " + str(value)
