extends Node

var room_number: int
var rooms: Array[String] = [
	"res://scenes/rooms/beginning.tscn",
	"res://scenes/rooms/sandwiched.tscn",
	"res://scenes/rooms/surrounded.tscn",
	"res://scenes/rooms/bad_situation.tscn",
	"res://scenes/rooms/new_friend.tscn"
]

func change_room():
	room_number += 1
	get_tree().change_scene_to_file(rooms[room_number])
