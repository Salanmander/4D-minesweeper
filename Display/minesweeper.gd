extends Control

var big_rows: int
var big_cols: int
var rows: int
var cols: int

var packed_layer_display: PackedScene = load("res://Display/layer_display.tscn")
var mine_board: Mine4D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Constants for number of rows/cols
	big_rows = 4
	big_cols = 6
	rows = 7
	cols = 9
	var mines = 40
	mine_board = Mine4D.new(big_rows, big_cols, rows, cols)
	setup_grid_display()
	mine_board.add_mines(mines)
	mine_board.calc_all_adjacent()
	
	get_node("VBox/Options").set_values(big_rows, big_cols, rows, cols, mines)
	pass # Replace with function body.
	
func setup_grid_display():
	var grid_node: Node = get_node("VBox/Scroll/LayerGrid")
	grid_node.columns = big_cols
	for r in big_rows:
		for c in big_cols:
			var layer_display: Node = packed_layer_display.instantiate()
			grid_node.add_child(layer_display)
			layer_display.set_big_location(r, c)
			layer_display.set_dimensions(rows, cols)
			mine_board.exploded.connect(layer_display.exploded)
			mine_board.mine_revealed.connect(layer_display.mine_revealed)
			mine_board.number_revealed.connect(layer_display.number_revealed)
			mine_board.blank_revealed.connect(layer_display.blank_revealed)
			
			layer_display.clicked.connect(mine_board.on_click.bindv([r, c]))
			layer_display.flag_changed.connect(mine_board.flag_changed.bindv([r, c]))
			
	# Connect signals between layers for highlighting
	var layer_displays: Array[Node] = grid_node.get_children()
	for disp in layer_displays:
		var enter_signal = disp.square_entered
		var big_r = disp.big_r
		var big_c = disp.big_c
		
		for other_disp in layer_displays:
			other_disp.connect_enter(enter_signal, big_r, big_c)
			pass
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_options_difference_toggled(display_diff: bool) -> void:
	mine_board.display_diff_changed(display_diff)
