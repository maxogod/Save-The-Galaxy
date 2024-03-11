extends Control


signal restart_button_press
signal main_menu_button_press
signal unlock_new_enemy(enemy_name)

@onready var high_score = $Panel/HighScore:
	set(value):
		high_score.text = "High score: " + str(value)
@onready var score = $Panel/Score:
	set(value):
		score.text = "Score: " + str(value)
@onready var enemies_killed_container = $Panel/EnemiesKilledContainer

@onready var common_sprite = $Panel/EnemiesKilledContainer/CommonSprite
@onready var common_label = $Panel/EnemiesKilledContainer/CommonLabel

@onready var glider_sprite = $Panel/EnemiesKilledContainer/GliderSprite
@onready var glider_label = $Panel/EnemiesKilledContainer/GliderLabel

@onready var fast_sprite = $Panel/EnemiesKilledContainer/FastSprite
@onready var fast_label = $Panel/EnemiesKilledContainer/FastLabel

@onready var rotor_sprite = $Panel/EnemiesKilledContainer/RotorSprite
@onready var rotor_label = $Panel/EnemiesKilledContainer/RotorLabel

@onready var tank_sprite = $Panel/EnemiesKilledContainer/TankSprite
@onready var tank_label = $Panel/EnemiesKilledContainer/TankLabel

@onready var radioactive_sprite = $Panel/EnemiesKilledContainer/RadioactiveSprite
@onready var radioactive_label = $Panel/EnemiesKilledContainer/RadioativeLabel

@onready var spectre_sprite = $Panel/EnemiesKilledContainer/SpectreSprite
@onready var spectre_label = $Panel/EnemiesKilledContainer/SpectreLabel

@onready var artillery_sprite = $Panel/EnemiesKilledContainer/ArtillerySprite
@onready var artillery_label = $Panel/EnemiesKilledContainer/ArtilleryLabel

var enemies_killed: Dictionary = {
		"CommonEnemy": 0,
		"GliderEnemy": 0,
		"RotorEnemy": 0,
		"FastEnemy": 0,
		"TankEnemy": 0,
		"RadioactiveEnemy": 0,
		"SpectreEnemy": 0,
		"ArtilleryEnemy": 0,
	}

var amount_of_kills_to_unlock_next_enemy = {
	"CommonEnemy": 3,
	"GliderEnemy": 2,
	"FastEnemy": 5,
	"RotorEnemy": 3,
	"TankEnemy": 3,
	"RadioactiveEnemy": 2,
	"SpectreEnemy": 5,
	"ArtilleryEnemy": 3,
	}

var amount_of_total_kills_to_unlock_enemy = {
	"CommonEnemy": 1,
	"GliderEnemy": 3,
	"FastEnemy": 8,
	"RotorEnemy": 17,
	"TankEnemy": 28,
	"RadioactiveEnemy": 36,
	"SpectreEnemy": 46,
	"ArtilleryEnemy": 57,
	}

var unlock_by_enemy = {
	"CommonEnemy": "GliderEnemy",
	"GliderEnemy": "FastEnemy",
	"FastEnemy": "RotorEnemy",
	"RotorEnemy": "TankEnemy",
	"TankEnemy": "RadioactiveEnemy",
	"RadioactiveEnemy": "SpectreEnemy",
	"SpectreEnemy": "ArtilleryEnemy",
	"ArtilleryEnemy": null,
	}

var unlocked_enemies = {
	"CommonEnemy": true,
	"GliderEnemy": false,
	"RotorEnemy": false,
	"FastEnemy": false,
	"TankEnemy": false,
	"RadioactiveEnemy": false,
	"SpectreEnemy": false,
	"ArtilleryEnemy": false,
	}

var total_kills = 0


func _process(delta):
	for key in enemies_killed:
		if enemies_killed[key] == 0: continue
		
		match key:
			"CommonEnemy":
				if not common_sprite or not common_label: break
				common_sprite.visible = true
				common_label.text = "X " + str(enemies_killed[key])
				common_label.visible = true
			"GliderEnemy":
				if not glider_sprite or not glider_label: break
				glider_sprite.visible = true
				glider_label.text = "X " + str(enemies_killed[key])
				glider_label.visible = true
			"FastEnemy":
				if not fast_sprite or not fast_label: break
				fast_sprite.visible = true
				fast_label.text = "X " + str(enemies_killed[key])
				fast_label.visible = true
			"RotorEnemy":
				if not rotor_sprite or not rotor_label: break
				rotor_sprite.visible = true
				rotor_label.text = "X " + str(enemies_killed[key])
				rotor_label.visible = true
			"TankEnemy":
				if not tank_sprite or not tank_label: break
				tank_sprite.visible = true
				tank_label.text = "X " + str(enemies_killed[key])
				tank_label.visible = true
			"RadioactiveEnemy":
				if not radioactive_sprite or not radioactive_label: break
				radioactive_sprite.visible = true
				radioactive_label.text = "X " + str(enemies_killed[key])
				radioactive_label.visible = true
			"SpectreEnemy":
				if not spectre_sprite or not spectre_label: break
				spectre_sprite.visible = true
				spectre_label.text = "X " + str(enemies_killed[key])
				spectre_label.visible = true
			"ArtilleryEnemy":
				if not artillery_sprite or not artillery_label: break
				artillery_sprite.visible = true
				artillery_label.text = "X " + str(enemies_killed[key])
				artillery_label.visible = true


func _on_restart_button_pressed():
	restart_button_press.emit()


func _on_main_menu_button_pressed():
	main_menu_button_press.emit()


func increase_kills(name):
	if name not in enemies_killed:
		enemies_killed[name] = 0
	enemies_killed[name] += 1
	total_kills += 1
	
	if not unlock_by_enemy[name]: return
	
	if amount_of_kills_to_unlock_next_enemy[name] <= enemies_killed[name] and not unlocked_enemies[unlock_by_enemy[name]]:
		print("Unlocking " + unlock_by_enemy[name])
		unlocked_enemies[unlock_by_enemy[name]] = true
		unlock_new_enemy.emit(unlock_by_enemy[name])
	
	for key in amount_of_total_kills_to_unlock_enemy.keys():
		if amount_of_total_kills_to_unlock_enemy[key] <= total_kills and not unlocked_enemies[key]:
			print("Unlocking " + key)
			unlocked_enemies[key] = true
			unlock_new_enemy.emit(key)


func clear_kills():
	for key in enemies_killed:
		enemies_killed[key] = 0
	total_kills = 0
	for key in unlocked_enemies:
		if key == "CommonEnemy": continue
		unlocked_enemies[key] = false
	common_sprite.visible = false
	common_label.visible = false
	glider_sprite.visible = false
	glider_label.visible = false
	fast_sprite.visible = false
	fast_label.visible = false
	rotor_sprite.visible = false
	rotor_label.visible = false
	tank_sprite.visible = false
	tank_label.visible = false
	radioactive_sprite.visible = false
	radioactive_label.visible = false
	spectre_sprite.visible = false
	spectre_label.visible = false
	artillery_sprite.visible = false
	artillery_label.visible = false
