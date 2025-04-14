extends Control


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
	
func display_mines(mines_grid: Array):
	$LayerDisplay.display_mines(mines_grid)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
