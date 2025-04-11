extends Node

func main():
	var new_mine: Mine4D = Mine4D.new(4, 6, 8, 10)
	new_mine.set_mine(3, 5, 7, 9, true)
	print(new_mine.is_mine(3, 5, 7 ,9))
	pass
