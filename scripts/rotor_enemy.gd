class_name RotorEnemy extends Enemy

@onready var animation = $AnimatedSprite2D
@onready var collisions = $CollisionShape2D


var SPEED = 200
var RADIUS := 5.0
var ROTATION_SPEED := 4.0
var time := 0.0
var HEALTH = 20
var SCORE_AUGMENT = 50
var INVASION_AUGMENT = 10


func _physics_process(delta):
	
	animation.rotation_degrees += 2
	
	time += delta
	position.x += RADIUS * cos(time * ROTATION_SPEED)
	position.y += RADIUS * sin(time * ROTATION_SPEED)
	position.y += SPEED * delta


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
