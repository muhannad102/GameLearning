extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const UP = Vector2(0, -1)
const GRAVITY = 20
const MAX_SPEED = 250
const ACCELERATION = 50
const JUMP_HEIGHT = -400
var motion = Vector2()
var breakingAnimationIsPlaying = false
var MAX_JUMP_COUNT = 0

func _ready():
	set_process_input(true)
	pass

func _physics_process(delta):
	
	motion.y += GRAVITY
	
	if Input.is_key_pressed(KEY_D):
		motion.x = min(motion.x + ACCELERATION , MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Run")
		
	elif Input.is_key_pressed(KEY_A):
		motion.x = max(motion.x - ACCELERATION , -MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Run")
	else:
		$Sprite.play("Idle")
		motion.x = lerp(motion.x, 0 , 0.2)
		
	if(motion.y < 0 ):
		$Sprite.play("Jump")
	elif(not is_on_floor()):
		$Sprite.play("Fall")  
	motion = move_and_slide(motion,UP)
	pass
	
func _input(event):
	if (Input.is_mouse_button_pressed(BUTTON_LEFT)):
		var mousePos = $Camera2D.get_global_mouse_position()
		position = mousePos
	if is_on_floor():
		if Input.is_action_pressed("ui_select"):
			motion.y = JUMP_HEIGHT
			MAX_JUMP_COUNT = 0
	else:
		if(motion.y < 0 ):
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")  
		if Input.is_action_just_pressed("ui_select") and MAX_JUMP_COUNT < 1:
			motion.y += JUMP_HEIGHT - motion.y
			MAX_JUMP_COUNT += 1
			
	pass