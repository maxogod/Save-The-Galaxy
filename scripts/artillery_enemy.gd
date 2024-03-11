class_name ArtilleryEnemy extends Enemy


@onready var collisions = $CollisionShape2D
@onready var animation = $AnimatedSprite2D
@onready var weapon = $Weapon
@onready var bomb_scene = preload("res://scenes/enemy_bomb.tscn")

var SPEED = 100
var HEALTH = 60
var SCORE_AUGMENT = 100
var INVASION_AUGMENT = 0


func _ready():
	global_position.x = get_viewport_rect().size.x / 2


func _physics_process(delta):
	if global_position.y < 150:
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


func _on_bomb_timer_timeout():
	shoot()


func shoot():
	enemy_bomb.emit(bomb_scene, weapon.global_position, null)
