extends Node

@onready var score_label: Label = %ScoreLabel
@onready var gui: CanvasLayer = %GUI


var score = 0

func add_point():
	score += 1
	gui.score.text = "Score: "+str(score)
