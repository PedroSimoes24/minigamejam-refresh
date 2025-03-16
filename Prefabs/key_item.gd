extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var player = get_tree().current_scene.find_child("Player")
@onready var ui: CanvasLayer = $"../UI"

@export var item_data: Resource

func _ready():
	connect("body_entered",_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.held_item = item_data
		var slot = ui.get_node("Hotbar/Slot")
		if item_data != null:
			slot.set_item(item_data)
			queue_free()
	pass
