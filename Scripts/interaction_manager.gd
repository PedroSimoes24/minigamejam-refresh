extends Node2D

@onready var player = get_tree().current_scene.find_child("Player")
@onready var label = $Label

const base_text = "[E] to "
const INTERACTION_DISTANCE = 30

var active_areas = []
var can_interact = true

func _ready():
	if player == null:
		print("Player node not found!")
		
func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area:InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		
		if player.global_position.distance_to(active_areas[0].global_position) > INTERACTION_DISTANCE:
			label.hide()
			return
		
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 36
		label.global_position.x -= label.size.x /2
		label.show()
	else:
		label.hide()

func _sort_by_distance_to_player(area1, area2):
	if player == null:
		return
	
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
