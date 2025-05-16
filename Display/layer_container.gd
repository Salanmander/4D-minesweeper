extends Control

var big_r: int
var big_c: int

var SCALE_SIZE: Vector2 = Vector2(2, 2)
var GRID_EXTRA_SPACING: Vector2 = Vector2(10, 10)

signal clicked(r: int, c: int)
signal adjacent_check(r: int, c: int)
signal flag_changed(r: int, c: int, flagged: int)
signal square_entered(r: int, c: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resize()
	$LayerDisplay.clicked.connect(emit_click)
	$LayerDisplay.adjacent_check.connect(emit_adjacent_check)
	$LayerDisplay.flag_changed.connect(emit_flag)
	$LayerDisplay.square_entered.connect(emit_enter)
	
	
	$LayerDisplay.scale = SCALE_SIZE
	$LayerDisplay.position = GRID_EXTRA_SPACING/2
	$HighlightDisplay.scale = SCALE_SIZE
	$HighlightDisplay.position = GRID_EXTRA_SPACING/2
	pass # Replace with function body.
	
func resize():
	var map_size = $LayerDisplay.get_used_rect().size
	var scale_factor = Vector2($LayerDisplay.tile_set.tile_size) * $LayerDisplay.scale
	custom_minimum_size = Vector2(map_size)*scale_factor + GRID_EXTRA_SPACING

	
func set_dimensions(rows: int, cols: int):
	$LayerDisplay.set_dimensions(rows, cols)
	$HighlightDisplay.set_dimensions(rows, cols)
	resize()
	
func set_big_location(r: int, c: int):
	big_r = r
	big_c = c

func connect_enter(to_connect: Signal, big_r: int, big_c: int):
	to_connect.connect(entered.bindv([big_r, big_c]))
	

func exploded(big_r: int, big_c: int, r: int, c: int):
	$LayerDisplay.lose()
	if big_r == self.big_r and big_c == self.big_c:
		$LayerDisplay.exploded(r, c)
		
func flag_loaded(big_r: int, big_c: int, r: int, c: int, flag_state: int):
	if big_r == self.big_r and big_c == self.big_c:
		$LayerDisplay.flag_loaded(r, c, flag_state)

func mine_revealed(big_r: int, big_c: int, r: int, c: int):
	if big_r == self.big_r and big_c == self.big_c:
		$LayerDisplay.mine_revealed(r, c)
		
		
func nomine_revealed(big_r: int, big_c: int, r: int, c: int):
	if big_r == self.big_r and big_c == self.big_c:
		$LayerDisplay.nomine_revealed(r, c)
		
func number_revealed(big_r: int, big_c: int, r: int, c: int, count: int):
	if big_r == self.big_r and big_c == self.big_c:
		$LayerDisplay.number_revealed(r, c, count)
		
func blank_revealed(big_r: int, big_c: int, r: int, c: int):
	if big_r == self.big_r and big_c == self.big_c:
		$LayerDisplay.blank_revealed(r, c)
		
func two_button_click(event: InputEvent):
	$LayerDisplay.two_button_click_if_local(event)
		
# Input order is different because big_r and big_c are passed from a bindv
func entered(r: int, c: int, big_r: int, big_c: int):
	$HighlightDisplay.clear_all()
	$LayerDisplay.adjacent_unindicate_all()
	if abs(self.big_r - big_r) <= 1 and abs(self.big_c - big_c) <= 1:
		for ch_r in [r-1, r, r+1]:
			for ch_c in [c-1, c, c+1]:
				if $LayerDisplay.in_map_bounds(ch_r, ch_c):
					var hidden: bool = $LayerDisplay.is_hidden(ch_r, ch_c)
					$HighlightDisplay.highlight(ch_r, ch_c, hidden)
					
					# TODO: test mouse modifications
					var left_held: bool = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
					var right_held: bool = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
					if Input.is_action_pressed("check_adjacent") or (left_held and right_held):
						$LayerDisplay.adjacent_indicate(ch_r, ch_c)
		#$HighlightDisplay.entered_nearby_layer(r, c)
		
		
func emit_click(r: int, c: int):
	clicked.emit(r, c)
	
	
func emit_adjacent_check(r: int, c: int):
	adjacent_check.emit(r, c)
	
func emit_flag(r: int, c: int, flagged: int):
	flag_changed.emit(r, c, flagged)
	
func emit_enter(r: int, c: int):
	square_entered.emit(r, c)
	
	
