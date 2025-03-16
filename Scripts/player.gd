extends Node2D

@onready var tile_map_layer: TileMapLayer = $"../Ground"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ui: CanvasLayer = $"../UI"

var current_scene = 1

@export var held_item: Item #item in hotbar

var is_moving = false
var halt_game = false
var interact_label = Label.new()



func _physics_process(delta):
	if halt_game:
		return
	
	if is_moving == false:
		return
	
	if global_position == sprite_2d.global_position:
		is_moving = false
		act()
		return
	
	# Move the sprite position to the global position set on move()
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 1)

func _process(delta):
	var current_tile: Vector2i = tile_map_layer.local_to_map(global_position)
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(current_tile)
	var adjacent_tile: Vector2i = current_tile + Vector2i.UP
	var adjacent_tile_data: TileData = tile_map_layer.get_cell_tile_data(adjacent_tile)
	if halt_game:
		return
	
	if is_moving:
		return
	
	if is_on_door():
		change_scene() # Change to your scene path
		
	if adjacent_tile_data.get_custom_data("enterable"):
			if held_item != null and held_item.resource_path == "res://Resources/key.tres":
				call_label("[E] to interact")
				if Input.is_action_just_pressed("interact"):
					try_interact()
			else:
				call_label("You're missing something")
	else:
		interact_label.hide()
	
	if Input.is_action_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_pressed("right"):
		move(Vector2.RIGHT)

func try_interact():
	var current_tile: Vector2i = tile_map_layer.local_to_map(global_position)
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(current_tile)
	var adjacent_tile: Vector2i = current_tile + Vector2i.UP
	var adjacent_tile_data: TileData = tile_map_layer.get_cell_tile_data(adjacent_tile)

	if adjacent_tile_data.get_custom_data("enterable"):
		if held_item != null and held_item.resource_path == "res://Resources/key.tres":
			
			#Replacing the tile of the closed door to open door
			var tile_source_id = tile_map_layer.get_cell_source_id(adjacent_tile)
			var new_tile_atlas_coords = Vector2i(0, 0)
			tile_map_layer.set_cell(adjacent_tile, tile_source_id, new_tile_atlas_coords)
			#Removing he key from the inventory
			held_item = null
			print("door opened")
		

func move(direction: Vector2):
	# Get current tile Vector2i
	var current_tile: Vector2i = tile_map_layer.local_to_map(global_position)
	
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(target_tile)
	if tile_data.get_custom_data("walkable") == false:
			return
			
	# Move player
	is_moving = true
	
	# Update player global position (actuall position)
	global_position = tile_map_layer.map_to_local(target_tile)
	
	# Set sprite position to the current one for smoothness
	sprite_2d.global_position = tile_map_layer.map_to_local(current_tile)

func act():
	# Get current_tile
	var current_tile: Vector2i = tile_map_layer.local_to_map(global_position)
	# Get custom data layer from the current tile
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(current_tile)
	
	#to check for door on top of player
	var adjacent_tile: Vector2i = current_tile + Vector2i.UP
	var adjacent_tile_data: TileData = tile_map_layer.get_cell_tile_data(adjacent_tile)
	
	if tile_data != null:
		if tile_data.get_custom_data("walkable") and tile_data.get_custom_data("fall"):
			fall()
		if tile_data.get_custom_data("walkable") and tile_data.get_custom_data("win"):
			win()

func fall():
	halt_game = true
	var tween = create_tween()
	var target_scale = Vector2(0,0)
	tween.set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 1.0)
	tween.tween_property(self, "rotation", 10, 1.0)
	
func win():
	halt_game = true
	print("gg")
	
	
func add_to_inventory(item:Resource):
	if held_item == null:
		held_item = item
	else:
		print("hotbar already with one item")

func update_hotbar():
	var hotbar = get_node("/root/testes/UI")
	var slot = ui.find_child("slot")
	slot.set_item(held_item)

func call_label(text: String):
	interact_label.show()
	interact_label.z_index = 20
	interact_label.text = text
	interact_label.add_theme_font_size_override("font_size", 5) 
	add_child(interact_label)
	interact_label.global_position = global_position + Vector2.LEFT * 28 + Vector2.UP * 13
	
	
func is_on_door() -> bool:
	var current_tile: Vector2i = tile_map_layer.local_to_map(global_position)
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(current_tile)

	if tile_data and tile_data.get_custom_data("teleport"):
		return true
	return false
	
func change_scene():
	var next_scene_path = "res://Scenes/level_" + str(current_scene) + ".tscn"
	print("Changing scene to: ", next_scene_path)
	get_tree().change_scene_to_file(next_scene_path)
	current_scene += 1
