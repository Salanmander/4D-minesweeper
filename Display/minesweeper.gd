extends Control

var big_rows: int
var big_cols: int
var rows: int
var cols: int

var display_diff: bool

var packed_layer_display: PackedScene = load("res://Display/layer_display.tscn")
var mine_board: Mine4D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_diff = true
	start_new_game(4, 6, 7, 9, 40)
	
func start_new_game(big_rows: int, big_cols: int, rows: int, cols: int, mines: int):
	# Constants for number of rows/cols
	self.big_rows = big_rows
	self.big_cols = big_cols
	self.rows = rows
	self.cols = cols
	mine_board = Mine4D.new(big_rows, big_cols, rows, cols)
	setup_grid_display()
	mine_board.add_mines(mines)
	mine_board.calc_all_adjacent()
	mine_board.display_diff_changed(display_diff)
	
	get_node("VBox/Options").set_values(big_rows, big_cols, rows, cols, mines)
	pass # Replace with function body.
	
func setup_grid_display():
	var grid_node: Node = get_node("VBox/Scroll/LayerGrid")
	var existing_layers: Array[Node] = grid_node.get_children()
	for layer: Node in existing_layers:
		layer.queue_free()
		grid_node.remove_child(layer)
		
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
			layer_display.adjacent_check.connect(mine_board.on_adjacent_check.bindv([r, c]))
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


func _input(event: InputEvent):	
		
	if event is InputEventMouseButton:
	
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				ButtonStates.right_button_down(event)
			else:
				ButtonStates.right_button_up(event)
				
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				ButtonStates.left_button_down(event)
			else:
				ButtonStates.left_button_up(event)
	
	elif event is InputEventKey:
		if event.keycode == KEY_C:
			if event.pressed:
				ButtonStates.c_down(event)
			else:
				ButtonStates.c_up(event)


func _on_options_difference_toggled(display_diff: bool) -> void:
	self.display_diff = display_diff
	mine_board.display_diff_changed(display_diff)


func _on_options_new_game_requested(big_rows: int, big_cols: int, rows: int, cols: int, mines: int) -> void:
	start_new_game(big_rows, big_cols, rows, cols, mines)
