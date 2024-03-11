extends HSlider

signal finished_saving
signal draged

@export var bus_name: String

var bus_index: int
var old_volume

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	load_volume()

func _on_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index, value)

func save_volume():
	# DirAccess.remove_absolute("user://volume.data")
	if old_volume == value:
		print("no volume changes")
		finished_saving.emit()
		return
	print("volume changes")
	var file = FileAccess.open("user://volume.data", FileAccess.WRITE)
	if file != null:
		file.store_float(value)
		file.close()
		finished_saving.emit()
	else:
		print("Error: Unable to open file for writing")

func load_volume():
	var file = FileAccess.open("user://volume.data", FileAccess.READ)
	if file != null:
		var loaded_volume = file.get_float()
		file.close()
		set_value(loaded_volume)
		old_volume = value
	else:
		set_value(0)
		old_volume = value


func _on_drag_ended(value_changed):
	draged.emit()
