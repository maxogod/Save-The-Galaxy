extends Control


@onready var game_container = $GameContainer
@onready var panel = $Panel
@onready var universe = $Universe
@onready var title = $Title
@onready var highscore_label = $HighScore
@onready var play_button = $PlayButton
@onready var quit_button = $QuitButton
@onready var button_sound = $Sounds/ButtonSound
@onready var laser_sound = $Sounds/LaserSound
@onready var volume_slider = $Sounds/VolumeSlider
@onready var volume_slider_label = $Sounds/VolumeSliderLabel
@onready var blue_laser_button = $Panel/SelectBlueLaser
@onready var red_laser_button = $Panel/SelectRedLaser
@onready var red_ship_button = $Panel/SelectRedShipButton
@onready var pink_ship_button = $Panel/SelectPinkShipButton
@onready var game_scene = preload("res://scenes/game.tscn")


var game
var menu_open = true
var high_score
var selected_ship: String
var selected_laser: String

# Called when the node enters the scene tree for the first time.
func _ready():
	volume_slider.finished_saving.connect(_quit)
	volume_slider.draged.connect(button_sound.play)
	red_ship_button.get_theme_stylebox("normal").bg_color = Color(0.3, 0.5, 1, 0.4)
	red_laser_button.get_theme_stylebox("normal").bg_color = Color(0.3, 0.5, 1, 0.4)
	load_high_score()
	highscore_label.text = "High score: " + str(high_score)
	panel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit") and menu_open:
		volume_slider.save_volume() # save volume and quit


func _on_play_button_pressed():
	button_sound.play()
	panel.visible = true
	volume_slider.visible = false
	volume_slider_label.visible = false


func _on_quit_button_pressed():
	button_sound.play()
	button_sound.finished.connect(volume_slider.save_volume)


func _quit():
	get_tree().quit()

func _on_back_button_pressed():
	button_sound.play()
	panel.visible = false
	volume_slider.visible = true
	volume_slider_label.visible = true


func _on_select_pink_ship_button_pressed():
	pink_ship_button.get_theme_stylebox("normal").bg_color = Color(0.3, 0.5, 1, 0.4)
	red_ship_button.get_theme_stylebox("normal").bg_color = Color(0, 0, 0, 0.4)
	laser_sound.play()
	selected_ship = "PINK"


func _on_select_red_ship_button_pressed():
	red_ship_button.get_theme_stylebox("normal").bg_color = Color(0.3, 0.5, 1, 0.4)
	pink_ship_button.get_theme_stylebox("normal").bg_color = Color(0, 0, 0, 0.4)
	laser_sound.play()
	selected_ship = "RED"


func _on_select_red_laser_pressed():
	red_laser_button.get_theme_stylebox("normal").bg_color = Color(0.3, 0.5, 1, 0.4)
	blue_laser_button.get_theme_stylebox("normal").bg_color = Color(0, 0, 0, 0.4)
	laser_sound.play()
	selected_laser = "RED"


func _on_select_blue_laser_pressed():
	blue_laser_button.get_theme_stylebox("normal").bg_color = Color(0.3, 0.5, 1, 0.4)
	red_laser_button.get_theme_stylebox("normal").bg_color = Color(0, 0, 0, 0.4)
	laser_sound.play()
	selected_laser = "BLUE"


func _on_ready_button_pressed():
	button_sound.play()
	button_sound.finished.connect(_start_game)

func _start_game():
	button_sound.finished.disconnect(_start_game)
	panel.visible = false
	game = game_scene.instantiate()
	game.set_ship_color(selected_ship)
	game.set_player_laser_color(selected_laser)
	game.high_score = high_score
	game.main_menu.connect(_back_to_main_menu)
	game.new_high_score.connect(_new_high_score)
	game_container.add_child(game)
	close_main_menu()


func close_main_menu():
	menu_open = false
	panel.visible = false
	universe.visible = false
	title.visible = false
	highscore_label.visible = false
	play_button.visible = false
	quit_button.visible = false
	volume_slider.visible = false
	volume_slider_label.visible = false
	

func _back_to_main_menu():
	game_container.remove_child(game)
	menu_open = true
	universe.visible = true
	title.visible = true
	highscore_label.visible = true
	play_button.visible = true
	quit_button.visible = true
	volume_slider.visible = true
	volume_slider_label.visible = true


func load_high_score():
	var file = FileAccess.open("user://save.data", FileAccess.READ)
	if file != null:
		high_score = file.get_32()
	else:
		high_score = 0


func _new_high_score(value):
	high_score = value
	highscore_label.text = "High score: " + str(value)
