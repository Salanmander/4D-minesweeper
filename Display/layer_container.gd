extends Control

var big_r: int
var big_c: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resize()
	pass # Replace with function body.
	
func resize():
	var map_size = $LayerDisplay.get_used_rect().size
	custom_minimum_size = map_size*$LayerDisplay.tile_set.tile_size
	
func set_dimensions(width: int, height: int):
	$LayerDisplay.set_dimensions(width, height)
	resize()
	
func set_big_location(r: int, c: int):
	big_r = r
	big_c = c
	
func mine_added(big_r: int, big_c: int, r: int, c: int):
	if big_r == self.big_r and big_c == self.big_c:
		$LayerDisplay.mine_added(r, c)
	
	
