class_name SpectreEnemy extends Enemy


@onready var collisions = $CollisionShape2D
@onready var animation = $AnimatedSprite2D
@onready var weapon_right = $WeaponRight
@onready var weapon_left = $WeaponLeft
@onready var laser_scene = preload("res://scenes/enemy_laser.tscn")

var SPEED = 300
var HEALTH = 10
var SCORE_AUGMENT = 60
var INVASION_AUGMENT = 13
var LASER_COLOR = Color(0, 0.4, 0.6, 1)
var shoot_right = [true, false][randi() % 2]
var fading = true
var alpha = 1


func _physics_process(delta):
	global_position.y += SPEED * delta


func _process(delta):
	
	if fading:
		alpha -= 0.01
	else:
		alpha += 0.01
	
	if alpha >= 0.8:
		fading = true
	elif alpha <= 0.2:
		fading = false
	
	animation.modulate = Color(1, 1, 1, alpha)
	
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


func _on_laser_timer_timeout():
	shoot()


func shoot():
	if shoot_right:
		enemy_laser_shot.emit(laser_scene, weapon_right.global_position, LASER_COLOR)
		shoot_right = false
	else:
		enemy_laser_shot.emit(laser_scene, weapon_left.global_position, LASER_COLOR)
		shoot_right = true
