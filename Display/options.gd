extends VBoxContainer

var packed_num_input: PackedScene = load("res://Menus/num_input.tscn")
var big_r_input: Control
var big_c_input: Control
var r_input: Control
var c_input: Control
var mines_input: Control

signal difference_toggled(display_diff: bool)
signal new_game_requested(big_rows: int, big_cols: int, rows: int, cols: int, mines: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grid_size_options()
	setup_other_options()
	
func setup_grid_size_options():
	var input: Control = packed_num_input.instantiate()
	input.set_label("big_r")
	big_r_input = input
	$GridSize.add_child(input)
	
	input = packed_num_input.instantiate()
	input.set_label("big_c")
	big_c_input = input
	$GridSize.add_child(input)
	
	input = packed_num_input.instantiate()
	input.set_label("r")
	r_input = input
	$GridSize.add_child(input)
	
	input = packed_num_input.instantiate()
	input.set_label("c")
	c_input = input
	$GridSize.add_child(input)
	
func setup_other_options():
	
	
	var input: Control = packed_num_input.instantiate()
	input.set_label("mines")
	input.set_max_val(999)
	mines_input = input
	$Other.add_child(input)
	
	var new_game_button: Button = Button.new()
	new_game_button.text = "New Game"
	new_game_button.pressed.connect(new_game)
	$Other.add_child(new_game_button)
	
	var difference_ticky: CheckBox = CheckBox.new()
	difference_ticky.text = "Show delta"
	difference_ticky.button_pressed = true
	difference_ticky.toggled.connect(difference_toggle)
	$Other.add_child(difference_ticky)
	
func set_values(big_rows: int, big_cols: int, rows: int, cols:int, mines:int):
	big_r_input.set_val(big_rows)
	big_c_input.set_val(big_cols)
	r_input.set_val(rows)
	c_input.set_val(cols)
	mines_input.set_val(mines)
	

func new_game():
	var big_rows = big_r_input.get_val()
	var big_cols = big_c_input.get_val()
	var rows = r_input.get_val()
	var cols = c_input.get_val()
	var mines = mines_input.get_val()
	new_game_requested.emit(big_rows, big_cols, rows, cols, mines)
	pass
	
func difference_toggle(selected: bool):
	difference_toggled.emit(selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
