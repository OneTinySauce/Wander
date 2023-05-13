extends Sprite2D


func open():
	self.frame = 1
	self.get_node("StaticBody2D/doorclosed").queue_free()
	$AudioStreamPlayer2D.play()
