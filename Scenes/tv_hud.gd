extends CanvasLayer

var glitched = true
var screenIdle
var screenReset
var smack
var smackTv
var opacity = 0.1  # Start fully invisible
var fade_timer  # Reference to the timer


func _ready():
	get_node("GlitchedAnimation").play("IdleAnimation")
	screenIdle = get_node("GlitchedAnimation")
	#smackTv = get_node("GlitchTV")
	#smackTv.play()
	#smackTv.hide()
	smack = get_node("SmackAnimation")
	
	
	smack.frame_changed.connect(_on_smack_animation_frame_changed)
	
	# Start invisible
	screenIdle.modulate.a = opacity

	# Create a Timer to fade in over time
	fade_timer = Timer.new()
	fade_timer.wait_time = 2  # Adjust for smooth fading
	fade_timer.autostart = true  # Start only when needed
	fade_timer.one_shot = false  # Loops until fully visible
	fade_timer.timeout.connect(_on_fade_timer_timeout)
	add_child(fade_timer)
	
func _on_fade_timer_timeout():
	if opacity < 1.0:
		opacity += 0.05  # Adjust fade speed
		opacity = min(opacity, 1.0)  # Clamp at 1.0
		screenIdle.modulate.a = opacity
	else:
		fade_timer.stop()  # Stop when fully visible
	
func _process(delta):
	
	if Input.is_action_just_released("smack_screen"):
		
		if glitched: 
			smack.show()
			smack.play()
				
			glitched = false
			
		else: 
			screenIdle.show()
			glitched = true
	



func _on_smack_animation_frame_changed() -> void:
	if smack.frame == 15   :
		screenIdle.hide()
		#play glithed animatiom
		#opacity = 1
		#screenIdle.modulate.a = opacity
		#smackTv.show()
		#var seconds = 2
		#var timer = Timer.new()
		#timer.wait_time = seconds  # Wait for the specified seconds
		#timer.one_shot = true  # The timer should only fire once
		#add_child(timer)  # Add the timer to the scene tree so it can start
		#timer.start()
		#smackTv.hide()
		
		
		opacity = 0.0  # Start fully invisible
		screenIdle.modulate.a = opacity
		screenIdle.show()
		fade_timer.start()  # Restart fade
