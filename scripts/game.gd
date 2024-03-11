extends Node2D

signal main_menu
signal new_high_score(value)

#@export var enemies: Array[PackedScene] = []

@onready var player_spawn_pos = $PlayerSpawnPos
@onready var timer = $EnemySpawnTimer
@onready var laser_container = $LaserContainer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gameover_scene = $UILayer/GameOverScreen
@onready var pb = $Universe
@onready var invasion_progress = $UILayer/InvasionProgress
@onready var player_scene = preload("res://scenes/player.tscn")
@onready var explosion_scene = preload("res://scenes/explosion.tscn")
@onready var button_sound = $Sounds/ButtonSound
@onready var ambient_music = $Sounds/AmbientMusic
@onready var laser_sound = $Sounds/LaserSound
@onready var hit_sound = $Sounds/HitSound
@onready var explosion_sound = $Sounds/ExplodeSound
@onready var player_death_sound = $Sounds/PlayerDeathSound
@onready var game_over_sound = $Sounds/GameOverSound
@onready var bomb_sound = $Sounds/BombSound
@onready var bomb_shot_sound = $Sounds/BombShot
@onready var explosion_container = $ExplosionsContainer

@onready var common_enemy_scene = preload("res://scenes/common_enemy.tscn")
@onready var glider_enemy_scene = preload("res://scenes/glider_enemy.tscn")
@onready var fast_enemy_scene = preload("res://scenes/fast_enemy.tscn")
@onready var rotor_enemy_scene = preload("res://scenes/rotor_enemy.tscn")
@onready var tank_enemy_scene = preload("res://scenes/tank_enemy.tscn")
@onready var radioactive_enemy_scene = preload("res://scenes/radioactive_enemy.tscn")
@onready var spectre_enemy_scene = preload("res://scenes/spectre_enemy.tscn")
@onready var artillery_enemy_scene = preload("res://scenes/artillery_enemy.tscn")

var player = null
var high_score
var SCROLL_SPEED = 100
var game_over_var
var player_ship_color: String
var player_laser_color: String

var current_enemies: Dictionary
var amount_of_enemies_allowed = {
		"CommonEnemy": 7,
		"GliderEnemy": 7,
		"RotorEnemy": 4,
		"FastEnemy": 3,
		"TankEnemy": 2,
		"RadioactiveEnemy": 2,
		"SpectreEnemy": 3,
		"ArtilleryEnemy": 1,
	}
var scene_of_enemy_class: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game Initialized")
	scene_of_enemy_class = {
		"CommonEnemy": common_enemy_scene,
		"GliderEnemy": glider_enemy_scene,
		"FastEnemy": fast_enemy_scene,
		"RotorEnemy": rotor_enemy_scene,
		"TankEnemy": tank_enemy_scene,
		"RadioactiveEnemy": radioactive_enemy_scene,
		"SpectreEnemy": spectre_enemy_scene,
		"ArtilleryEnemy": artillery_enemy_scene,
	}
	current_enemies = {
		"CommonEnemy": common_enemy_scene, # Only one available from the start
	}
	hud.score = 0
	game_over_var = false
	invasion_progress.value = 0
	gameover_scene.visible = false
	gameover_scene.restart_button_press.connect(restart_button_press)
	gameover_scene.main_menu_button_press.connect(open_main_menu)
	gameover_scene.unlock_new_enemy.connect(_on_enemy_unlock)
	player = player_scene.instantiate()
	player.set_color(player_ship_color)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.player_death.connect(_on_player_death)
	self.add_child(player)
	ambient_music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		_open_main_menu()
	elif Input.is_action_just_pressed("reset") and not game_over_var:
		_restart()
	
	accelerate_game(delta) # makes the game harder over time
	move_background(delta)


func restart_button_press():
	button_sound.play()
	button_sound.finished.connect(_restart)


func _restart():
	gameover_scene.clear_kills()
	current_enemies.clear()
	current_enemies["CommonEnemy"] = common_enemy_scene
	hud.score = 0
	hud.set_lives(3)
	game_over_var = false
	invasion_progress.value = 0
	gameover_scene.visible = false
	if not player:
		player = player_scene.instantiate()
		player.set_color(player_ship_color)
		player.laser_shot.connect(_on_player_laser_shot)
		player.player_death.connect(_on_player_death)
		self.add_child(player)
	player.global_position = player_spawn_pos.global_position
	for child in enemy_container.get_children():
		enemy_container.remove_child(child)
	SCROLL_SPEED = 100
	timer.wait_time = 2
	ambient_music.play()


func set_ship_color(color):
	player_ship_color = color


func set_player_laser_color(color):
	player_laser_color = color


func open_main_menu():
	button_sound.play()
	button_sound.finished.connect(_open_main_menu)


func _open_main_menu():
	main_menu.emit()


func accelerate_game(delta):
	if timer.wait_time > 1:
		timer.wait_time -= 0.005 * delta # decrease spawn intervals
		SCROLL_SPEED += 5 * delta # increase flying velocity


func move_background(delta):
	pb.scroll_offset.y += delta*SCROLL_SPEED


func _on_player_laser_shot(laser_scene, location):
	laser_sound.play()
	var laser = laser_scene.instantiate()
	laser.set_color(player_laser_color)
	laser.global_position = location
	laser.laser_hit.connect(_on_laser_hit)
	laser_container.add_child(laser)


func _on_enemy_laser_shot(laser_scene, location, color):
	if game_over_var: return
	laser_sound.play()
	var laser = laser_scene.instantiate()
	laser.set_color(color)
	laser.global_position = location
	laser.laser_hit.connect(_on_laser_hit)
	laser_container.add_child(laser)


func _on_enemy_bomb(bomb_scene, location, color):
	if game_over_var: return
	bomb_shot_sound.play()
	var bomb = bomb_scene.instantiate()
	bomb.set_color(color)
	bomb.global_position = location
	bomb.laser_hit.connect(_on_laser_hit)
	bomb.bomb_explosion.connect(_on_bomb_explosion)
	laser_container.add_child(bomb)


func _on_bomb_explosion():
	bomb_sound.play()


func _on_laser_hit():
	hit_sound.play()


func _on_enemy_unlock(enemy_name):
	current_enemies[enemy_name] = scene_of_enemy_class[enemy_name]


func _on_enemy_spawn_timer_timeout():
	if current_enemies.size() == 0: return
	var e = current_enemies[current_enemies.keys()[randi() % current_enemies.size()]].instantiate()
	e.global_position = Vector2(randi_range(50, get_viewport_rect().size.x - 50), -50)
	e.enemy_death.connect(_on_enemy_death)
	e.enemy_reached_goal.connect(_on_enemy_reached_goal)
	e.enemy_laser_shot.connect(_on_enemy_laser_shot)
	e.enemy_bomb.connect(_on_enemy_bomb)
	amount_of_enemies_allowed[e.name] -= 1
	if amount_of_enemies_allowed[e.name] == 0:
		current_enemies.erase(e.name)
	e.name = e.name + "_" # to separate numeration from class name
	enemy_container.add_child(e, true)


func _on_enemy_death(enemy):
	var explosion = explosion_scene.instantiate()
	explosion.scale = enemy.get_sprite_scale()
	explosion.global_position = enemy.global_position
	explosion_container.add_child(explosion)
	explosion_sound.play()
	hud.score = enemy.augment_score(hud.score.text.to_int())
	var enemy_name = enemy.name.split("_")[0] # split class name and numeration -> example: CommonEnemy_3
	if amount_of_enemies_allowed[enemy_name] <= 0:
		amount_of_enemies_allowed[enemy_name] = 0
		current_enemies[enemy_name] = scene_of_enemy_class[enemy_name]
	amount_of_enemies_allowed[enemy_name] += 1
	gameover_scene.increase_kills(enemy_name)

func _on_enemy_reached_goal(enemy):
	var enemy_name = enemy.name.split("_")[0] # split class name and numeration -> example: CommonEnemy_3
	if amount_of_enemies_allowed[enemy_name] <= 0:
		amount_of_enemies_allowed[enemy_name] = 0
		current_enemies[enemy_name] = scene_of_enemy_class[enemy_name]
	amount_of_enemies_allowed[enemy_name] += 1
	invasion_progress.value = enemy.augment_invasion_progress(invasion_progress.value)
	if invasion_progress.value >= 100 and not game_over_var:
		game_over_var = true
		game_over()


func _on_player_death():
	var explosion = explosion_scene.instantiate()
	explosion.scale = player.get_sprite_scale()
	explosion.global_position = player.global_position
	explosion_container.add_child(explosion)
	player_death_sound.play()
	game_over_var = hud.decrease_life()
	if game_over_var:
		game_over()
		return
	player = player_scene.instantiate()
	player.set_color(player_ship_color)
	player.global_position = player_spawn_pos.global_position
	player.invulnerable()
	self.add_child(player)
	player.laser_shot.connect(_on_player_laser_shot)
	player.player_death.connect(_on_player_death)


func game_over():
	if ambient_music.playing:
		ambient_music.stop()
	game_over_sound.play()
	await get_tree().create_timer(0.4).timeout
	if player != null:
		self.remove_child(player)
	gameover_scene.score = hud.score.text
	if hud.score.text.to_int() > high_score:
		high_score = hud.score.text.to_int()
		gameover_scene.high_score = high_score
		new_high_score.emit(high_score)
		save_game()
	else:
		gameover_scene.high_score = high_score
	gameover_scene.visible = true


func save_game():
	var file = FileAccess.open("user://save.data", FileAccess.WRITE)
	file.store_32(high_score)
