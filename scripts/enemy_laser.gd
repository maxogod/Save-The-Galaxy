class_name EnemyLaser extends Area2D

signal laser_hit()

@onready var sprite = $Sprite2D

var SPEED = 600
var color


func _ready():
	if not color:
		pass
	elif color:
		sprite.self_modulate = Color(1, 1, 1, 1)
		sprite.modulate = color


func _physics_process(delta):
	global_position.y += SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	print("Enemy Laser has exited the screen")


func on_laser_collision(damage):
	pass


func set_color(given_color):
	color = given_color


func _on_body_entered(body):
	laser_hit.emit()
	body.die()
	queue_free()


func on_enemy_ship_collision():
	pass


func on_ship_collision():
	pass
