extends Node2D

var big_rows: int
var big_cols: int
var rows: int
var cols: int

var packed_layer_display: PackedScene = load("res://Display/layer_display.tscn")
var mine_board: Mine4D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	big_rows = 3
	big_cols = 4
	rows = 8
	cols = 5
	mine_board = Mine4D.new(big_rows, big_cols, rows, cols)
	setup_grid_display()
	mine_board.add_mines(10)
	pass # Replace with function body.
	
func setup_grid_display():
	$LayerGrid.columns = big_cols
	for r in big_rows:
		for c in big_cols:
			var layer_display: Node = packed_layer_display.instantiate()
			$LayerGrid.add_child(layer_display)
			layer_display.set_big_location(r, c)
			layer_display.set_dimensions(rows, cols)
			mine_board.mine_added.connect(layer_display.mine_added)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
