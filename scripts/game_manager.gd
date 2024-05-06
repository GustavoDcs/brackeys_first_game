extends Node

var score = 0
var speed = 0

@onready var score_label = $ScoreLabel

func add_point():
	score += 1

func update_speed_label(actual_speed):
	speed = actual_speed
