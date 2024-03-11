class_name Enemy extends Area2D

signal enemy_death(enemy)
signal enemy_reached_goal(enemy)
signal enemy_laser_shot(laser_scene, location, color)
signal enemy_bomb(bomb_scene, location, color)


func _on_visible_on_screen_notifier_2d_screen_exited():
	if self.global_position.y > get_viewport_rect().size.y - 100:
		reach_goal()
		print("Enemy has exited the screen")


func _on_area_entered(area):
	area.on_enemy_ship_collision()


func _on_body_entered(body):
	body.on_enemy_ship_collision()
	on_ship_collision()


func on_laser_collision(damage):
	pass


func on_ship_collision():
	die()


func on_enemy_ship_collision():
	pass


func die():
	enemy_death.emit(self)
	queue_free()


func destroy():
	queue_free()


func reach_goal():
	enemy_reached_goal.emit(self)
	queue_free()
