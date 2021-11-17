extends KinematicBody2D

onready	var Player : KinematicBody2D = get_tree().get_root().find_node("Player", true, false)
onready var hitbox : Area2D = get_node("friend_hitbox")
onready var sprite : Sprite = get_node("Sprite")

var max_x_offset : int = 50
var max_distance : int = 0

var collected : bool = false
var order : int = 0

var frame : int = 0

func _ready():
	var p = get_tree().get_root().find_node("Player", true, false)
	p.connect("friend_collected", self, "friend_signal_received")

func friend_signal_received():
	if !collected:
		order += 1

func follow_player():
	global_position.y = Player.global_position.y - 25
	if global_position.x < Player.global_position.x - max_distance:
		global_position.x = Player.global_position.x - max_distance
	elif global_position.x > Player.global_position.x + max_distance:
		global_position.x = Player.global_position.x + max_distance
	
	# Sprite direction
	if global_position.x < Player.global_position.x:
		sprite.flip_h = false
	elif global_position.x > Player.global_position.x:
		sprite.flip_h = true

func _physics_process(delta):
	# Follow player if collected
	if collected:
		follow_player()
		
	# Floating
	global_position.y += 2 * sin(delta * frame * 6)
	
	frame += 1

func _on_friend_hitbox_area_entered(area):
	if "player_collect" in area.name:
		collected = true
		hitbox.set_deferred("monitorable", false) 
		max_distance = (order + 1) * max_x_offset
