extends Control

@onready var menu: CanvasLayer = $Menu

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	
	if Input.is_action_pressed("esc"):
		if get_tree().paused == false:
			menu.show()
			get_tree().paused = true
			
			
		
func _on_resume_pressed() -> void:
	menu.hide()
	get_tree().paused = false
