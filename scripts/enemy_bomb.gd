class_name EnemyBomb extends Area2D

signal laser_hit()
signal bomb_explosion()

@onready var animation = $AnimatedSprite2D
@onready var bomb_collision = $BombCollision
@onready var explosion_collision = $ExplosionCollision

var SPEED = 500
var color
var rand_speed_decrease = randi_range(3, 10)
var rand_speed_decrease_x = randf_range(0.5, 5) * [1, -1][randi() % 2]
var fading = true
var alpha = 1
var exploding = false


func _ready():
	explosion_collision.disabled = true
	if not color:
		pass
	elif color:
		animation.self_modulate = Color(1, 1, 1, 1)
		animation.modulate = color


func _physics_process(delta):
	global_position.y += SPEED * delta
	if rand_speed_decrease_x != 0 and (rand_speed_decrease_x > 1 or rand_speed_decrease_x < -1):
		global_position.x += (SPEED / rand_speed_decrease_x) * delta
	if SPEED >= rand_speed_decrease:
		SPEED -= rand_speed_decrease
	else:
		SPEED = 0
	global_position = global_position.clamp(Vector2(10, 50), Vector2(get_viewport_rect().size.x - 30, get_viewport_rect().size.y -50))


func _process(delta):
	if exploding:
		animation.scale += Vector2(0.01, 0.01)
		explosion_collision.scale += Vector2(0.01, 0.01)
	if fading:
		alpha -= 0.02
	else:
		alpha += 0.02
	
	if alpha >= 0.8:
		fading = true
	elif alpha <= 0.4:
		fading = false
	
	animation.modulate = Color(1, 1, 1, alpha)


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


func _on_explosion_timer_timeout():
	exploding = true
	bomb_explosion.emit()
	animation.modulate = Color(1, 1, 1, 1)
	animation.animation = "exploding"
	bomb_collision.disabled = true
	explosion_collision.disabled = false
	get_tree().create_timer(0.5).timeout.connect(destroy)


func destroy():
	queue_free()
