extends KinematicBody2D

# Need points to win!
var score : int = 0

# Movement constants
var max_speed : int = 300
var jump_force : int = 600
var gravity : int = 1100

# Stores the velocity of Player
var vel : Vector2 = Vector2()

# For animations
var moving : bool = false

# For collisions with enemies
var in_control : bool = true
var direction : int = 1

# Access the sprite node for animations
onready var sprite : AnimatedSprite = get_node("AnimatedSprite")

# Signals :)
signal friend_collected
signal game_over

func take_damage():
	in_control = false
	vel.x =  direction * -1 * max_speed / 2
	vel.y = -1 * jump_force / 2
	
# Called every frame (delta is the time one frame is active)
func _physics_process(delta):
	if Input.is_action_just_pressed("Reset"):
		emit_signal("game_over")
	
	if is_on_floor():
		in_control = true
	
	# horizontal movement
	if in_control:
		vel.x = 0
		if Input.is_action_pressed("move_left"):
			vel.x -= max_speed
			moving = true
			direction = -1
		elif Input.is_action_pressed("move_right"):
			vel.x += max_speed
			moving = true
			direction = 1
		
		# jump action
		if Input.is_action_just_pressed("jump") and is_on_floor():
			vel.y = -1 * jump_force
	
	# apply gravity
	vel.y += gravity * delta
	
		
	# animation control
	if !in_control:
		sprite.play("hurt")
	elif  is_on_floor() and vel.x != 0:
		sprite.play("run")
	elif !is_on_floor():
		sprite.play("jump")
	else:
		sprite.play("idle")
		
	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false
	
	if vel.y > 600 and in_control:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	
	# move the player
	vel = move_and_slide(vel, Vector2.UP)

# Handles signal for when we get hit by an enemy (hurtbox)
func _on_player_hurtbox_area_entered(area):
	if "enemy_hitbox" in area.name:
		take_damage()

# Handles signal for bouncing on enemy (hitbox)
func _on_player_hitbox_area_entered(area):
	if "enemy_hurtbox" in area.name:
		vel.y = -1 * jump_force / 1.5
		in_control = true

func _on_player_collect_box_area_entered(area):
	if "friend_hitbox" in area.name:
		emit_signal("friend_collected")
		score += 1
	if "goal" in area.name:
		if score == 3:
			emit_signal("game_over")
