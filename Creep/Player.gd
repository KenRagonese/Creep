extends Area2D

signal hit

export var speed = 600  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var last_velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	$AnimatedSprite.play()
	#position.rotated(deg2rad(90))
	velocity = apply_user_inputs_to_movement(velocity)
	if last_velocity != velocity:
		last_velocity = velocity
		print(velocity)
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed	
		position = update_position(position, velocity, delta)
		
	else:
        $AnimatedSprite.stop()
		
	
	if round(velocity.x) != 0:
		
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif round(velocity.y) != 0:
		$AnimatedSprite.animation = "up"
		#$AnimatedSprite.flip_h = false
		$AnimatedSprite.flip_v = velocity.y > 0
		
func process_keyboard_input(velocity):
	if Input.is_action_pressed("ui_right"):
        velocity.x += 1
	if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
        velocity.y += 1
	if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
	return velocity
	
func process_mouse_input(velocity):
	var mouse_position = get_viewport().get_mouse_position()
	var distance_threshold = 10
	if (mouse_position.x - position.x) > distance_threshold:
		velocity.x += 1
	if (mouse_position.x - position.x) < -distance_threshold:
		velocity.x -= 1
	if (mouse_position.y - position.y) > distance_threshold:
		velocity.y += 1
	if (mouse_position.y - position.y) < -distance_threshold:
		velocity.y -= 1
	return velocity
		
func apply_user_inputs_to_movement(velocity):
	velocity = process_keyboard_input(velocity)
	velocity = process_mouse_input(velocity)
	return velocity
	
func update_position(position, velocity, delta):
	var vd_modified_position = position + (velocity * delta)
	
	#position.rotation += PI/2
	var clamped_position = clamp_position(vd_modified_position)
	return clamped_position
	
#func rotate_position(position, velocity)
#
	
func clamp_position(position):
	var clamp_position = position
	clamp_position.x = clamp(clamp_position.x, 0, screen_size.x)
	clamp_position.y = clamp(clamp_position.y, 0, screen_size.y)
	return clamp_position
	
func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	Input.set_mouse_mode(0)
	emit_signal("hit")
	$CollisionShape2D.call_deferred("set_disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	Input.set_mouse_mode(1)