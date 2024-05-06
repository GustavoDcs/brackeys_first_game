extends CanvasLayer

@onready var coin_label = $Holder/CoinLabel
@onready var speed_label = $Holder/SpeedLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	speed_label.text = "Speed " + str(snapped(GameManager.speed, 0))
	coin_label.text = "Coins " + str(GameManager.score)
	pass

