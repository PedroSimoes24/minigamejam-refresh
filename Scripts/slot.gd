extends Button

@onready var player = get_tree().current_scene.find_child("player")

@export var item : Item = null:
	set(value):
		item = value
		if value != null:
			icon = value.icon
		else:
			icon = null
			
#func use_item(): <- this function should exist at some point i think
