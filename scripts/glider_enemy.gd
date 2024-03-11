class_name GliderEnemy extends Enemy


@onready var animation = $AnimatedSprite2D
@onready var collisions = $CollisionShape2D


var SPEED = 400
var HEALTH = 10
var SCORE_AUGMENT = 10
var INVASION_AUGMENT = 5
var going_right = true


func _ready():
	going_right = global_position.x >= get_viewport_rect().size.x / 2

func _physics_process(delta):
	global_position.y += SPEED * delta
	
	if going_right:
		global_position.x += (SPEED / 3) * delta
		animation.rotation_degrees = 160
	else:
		global_position.x += (-SPEED / 3) * delta
		animation.rotation_degrees = 205
	if global_position.x >= get_viewport_rect().size.x - 50:
		going_right = false
	elif global_position.x <= 50:
		going_right = true


func _process(delta):
	if HEALTH <= 0:
		die()
	if not get_viewport_rect().has_point(global_position):
		collisions.disabled = true
	elif collisions.disabled:
		collisions.disabled = false

func on_laser_collision(damage):
	HEALTH -= damage


func augment_score(score):
	return score + SCORE_AUGMENT


func augment_invasion_progress(progress):
	return progress + INVASION_AUGMENT


func get_sprite_scale():
	return animation.scale
