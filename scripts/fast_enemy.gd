class_name FastEnemy extends Enemy


@onready var collisions = $CollisionShape2D
@onready var animation = $AnimatedSprite2D

var SPEED = 600
var HEALTH = 10
var SCORE_AUGMENT = 15
var INVASION_AUGMENT = 7


func _physics_process(delta):
	global_position.y += SPEED * delta


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
