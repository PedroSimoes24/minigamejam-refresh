extends Button

@onready var player = get_tree().current_scene.find_child("Player")
var item : Item = null
	
	
func set_item(new_item: Item):
	item = new_item
	if new_item != null:
		icon = new_item.icon
		name = new_item.name
	else:
		icon = null
