extends Node

var room_number: int = 1

func change_room():
	room_number += 1
	get_tree().change_scene_to_file("res://scenes/rooms/jackies_room" + str(room_number) + ".tscn")
