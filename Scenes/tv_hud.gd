extends CanvasLayer

var glitched = true
var screen
var smack

func _ready():
	get_node("GlitchedAnimation").play("default")
	screen = get_node("GlitchedAnimation")
	smack = get_node("SmackAnimation")
	
	smack.frame_changed.connect(_on_smack_animation_frame_changed)
	
func _process(delta):
	
	if Input.is_action_just_released("smack_screen"):
		
		if glitched: 
			smack.show()
			smack.play()
				
			glitched = false
			
		else: 
			screen.show()
			glitched = true
	
	


func _on_smack_animation_frame_changed() -> void:
	if smack.frame == 15   :
		screen.hide()
