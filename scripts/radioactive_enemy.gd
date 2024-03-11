class_name RadioactiveEnemy extends Enemy


@onready var collisions = $CollisionShape2D
@onready var animation = $AnimatedSprite2D

var SPEED = 200
var HEALTH = 20
var SCORE_AUGMENT = 25
var INVASION_AUGMENT = 7
var RADIUS := 5
var ROTATION_SPEED := 2.0
var time := 0.0
var going_right = [true, false][randi() % 2]

func _physics_process(delta):

	time += delta
	if going_right:
		position.x += (RADIUS * cos(time * ROTATION_SPEED))
	else:
		position.x -= (RADIUS * cos(time * ROTATION_SPEED))
	position.y += RADIUS * cos(time * ROTATION_SPEED)
	position.y += SPEED * delta
	
	global_position = global_position.clamp(Vector2(0, -200), Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y + 500))

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


func _on_radiation_body_entered(body):
	body.die()


func _on_radiation_area_entered(area):
	pass
