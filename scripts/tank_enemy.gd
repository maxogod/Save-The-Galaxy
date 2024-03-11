class_name TankEnemy extends Enemy


@onready var collisions = $CollisionShape2D
@onready var animation = $AnimatedSprite2D
@onready var weapon = $Weapon
@onready var laser_scene = preload("res://scenes/enemy_laser.tscn")

var SPEED = 200
var HEALTH = 50
var SCORE_AUGMENT = 75
var INVASION_AUGMENT = 20


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


func _on_laser_timer_timeout():
	shoot()


func shoot():
	enemy_laser_shot.emit(laser_scene, weapon.global_position, null)
