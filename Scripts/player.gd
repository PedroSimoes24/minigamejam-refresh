extends Node2D

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var slot: Button = $Hotbar/Slot

var is_moving = false


func _physics_process(delta):
	if is_moving == false:
		return
	
	if global_position == sprite_2d.global_position:
		is_moving = false
		return
	
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 1)

func _process(delta):
	if is_moving:
		return
	
	if Input.is_action_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_pressed("right"):
		move(Vector2.RIGHT)


func move(direction: Vector2):
	# Get current tile Vector2i
	var current_tile: Vector2i = tile_map_layer.local_to_map(global_position)
	
	# Get target tile Vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	
	# Get custom data layer from the target tile
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(target_tile)
	if tile_data != null:
		if tile_data.get_custom_data("walkable") and tile_data.get_custom_data("fall"):
			fall()
		if tile_data.get_custom_data("walkable") and tile_data.get_custom_data("win"):
			win()
		if tile_data.get_custom_data("enterable") and slot.icon == "res://Assets/key.png":
			print("weee")
		if tile_data.get_custom_data("walkable") == false:
			return 
			
	# Move player
	is_moving = true
	
	global_position = tile_map_layer.map_to_local(target_tile)
	
	sprite_2d.global_position = tile_map_layer.map_to_local(current_tile)

func fall():
	var tween = create_tween()
	var target_scale = Vector2(0,0)
	tween.set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 1.0)
	tween.tween_property(self, "rotation", 10, 1.0)
	
func win():
	print("gg")
