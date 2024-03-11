extends Control

@onready var score = $Score:
	set(value):
		score.text = str(value)
@onready var galaxy_container = $GalaxyContainer

@export var lives = 3

var galaxy_scene = preload("res://scenes/galaxy.tscn")
var galaxies = []

func _ready():
	for i in range(lives):
		var galaxy = galaxy_scene.instantiate()
		galaxy.global_position.x = (70 * i) + 40
		galaxies.append(galaxy)
		galaxy_container.add_child(galaxy)

# Returns TRUE if gameover
func decrease_life():
	lives -= 1
	if lives < 0:
		return true
	galaxy_container.remove_child(galaxies[lives])
	galaxies.pop_back()
	return false


func increase_life():
	lives += 1
	var galaxy = galaxy_scene.instantiate()
	galaxy.global_position.x = (70 * (lives-1)) + 40
	galaxies.append(galaxy)
	galaxy_container.add_child(galaxy)


func set_lives(value):
	for i in range(len(galaxies)):
		var g = galaxies.pop_back()
		galaxy_container.remove_child(g)
	lives = value
	for i in range(value):
		var galaxy = galaxy_scene.instantiate()
		galaxy.global_position.x = (70 * i) + 40
		galaxies.append(galaxy)
		galaxy_container.add_child(galaxy)
