class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)
signal player_death()

@export var SPEED = 400
@export var fire_rate = 0.25

@onready var red_ship_animation = $RedShipSprite
@onready var pink_ship_animation = $PinkShipSprite
@onready var collision = $CollisionPolygon2D
@onready var weapon = $Weapon

var RESPAWN_INVULNERAVILTY_TIME = 2
var laser_scene = preload("res://scenes/laser.tscn")
var shoot_cd := false
var invulnerability = false
var pulsing = false
var alpha = 1
var fading = true
var color
var animation
var dying = false


func _ready():
	if not color or color == "RED":
		pink_ship_animation.visible = false
		red_ship_animation.visible = true
		animation = red_ship_animation
	elif color == "PINK":
		red_ship_animation.visible = false
		pink_ship_animation.visible = true
		animation = pink_ship_animation


func _process(delta):
	if red_ship_animation.animation == "death" or pink_ship_animation.animation == "death":
		return
	if Input.is_action_pressed("shoot") and !shoot_cd:
		shoot_cd = true
		shoot()
		await get_tree().create_timer(fire_rate).timeout
		shoot_cd = false
	if invulnerability:
		pulsing = true
		collision.disabled = true
		await get_tree().create_timer(RESPAWN_INVULNERAVILTY_TIME).timeout
		invulnerability = false
		collision.disabled = false
		pulsing = false
		red_ship_animation.modulate = Color(1, 1, 1, 1)
		pink_ship_animation.modulate = Color(1, 1, 1, 1)
		alpha = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if red_ship_animation.animation == "death" or pink_ship_animation.animation == "death":
		return
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity = direction * SPEED
	
	if velocity != Vector2.ZERO and (red_ship_animation.animation != "death" or pink_ship_animation.animation != "death"):
		red_ship_animation.play("flying")
		pink_ship_animation.play("flying")
	elif red_ship_animation.animation != "still" and pink_ship_animation.animation != "still" and (red_ship_animation.animation != "death" or pink_ship_animation.animation != "death"):
		red_ship_animation.play("still")
		pink_ship_animation.play("still")
	
	if pulsing:
		if fading:
			alpha -= 0.1
		else:
			alpha += 0.1
		
		if alpha >= 0.8:
			fading = true
		elif alpha <= 0.2:
			fading = false
		
		red_ship_animation.modulate = Color(1, 1, 1, alpha)
		pink_ship_animation.modulate = Color(1, 1, 1, alpha)
	
	move_and_slide()
	
	global_position = global_position.clamp(Vector2(30, 50), Vector2(get_viewport_rect().size.x - 30, get_viewport_rect().size.y -50))


func shoot():
	laser_shot.emit(laser_scene, weapon.global_position)


func on_laser_collision(damage):
	pass


func on_enemy_ship_collision():
	die()


func die():
	if dying: return
	dying = true
	collision.disabled = true
	player_death.emit()
	queue_free()


func invulnerable():
	invulnerability = true


func set_color(given_color: String):
	self.color = given_color


func get_sprite_scale():
	return animation.scale
