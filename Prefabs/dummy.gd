extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite2D


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact():
	sprite.frame = 1 if sprite.frame == 0 else 0
	
