class_name Laser extends Area2D

signal laser_hit()

@onready var sprite = $Sprite2D

var SPEED = 600
var DAMAGE = 10
var color


func _ready():
	if not color or color == "RED":
		pass
	elif color == "BLUE":
		sprite.modulate = Color(1, 5, 100 ,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position.y += -SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	print("Laser has exited the screen")


func _on_area_entered(area):
	area.on_laser_collision(DAMAGE)


func on_laser_collision(damage):
	pass


func on_enemy_ship_collision():
	laser_hit.emit()
	queue_free()


func on_ship_collision():
	queue_free()


func set_color(given_color):
	color = given_color
