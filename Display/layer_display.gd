extends TileMapLayer

var rows: int
var cols: int 

var lost: bool

var left_held: bool = false
var right_held: bool = false


var ATLAS_ID: int = 0

var ZERO_ROW: int = 1
var EXTRAS_ROW: int = 3

var BLANK: Vector2i = Vector2i(4, EXTRAS_ROW)
var HIDDEN: Vector2i = Vector2i(5, EXTRAS_ROW)
var ADJACENT: Vector2i = Vector2i(6, EXTRAS_ROW)
var FLAGGED: Vector2i = Vector2i(0, EXTRAS_ROW)
var QUESTIONED: Vector2i = Vector2i(1, EXTRAS_ROW)
var MINE_TILE: Vector2i = Vector2i(3, EXTRAS_ROW)
var EXPLODED_MINE_TILE: Vector2i = Vector2i(2, EXTRAS_ROW)


signal clicked(r: int, c: int)
signal flag_changed(r: int, c: int, flagged: int)
signal square_entered(r: int, c: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func set_dimensions(rows: int, cols: int):
	clear()
	self.rows = rows
	self.cols = cols
	for r in range(rows):
		for c in range(cols):
			set_cell(Vector2i(c, r), ATLAS_ID, HIDDEN)
			pass
			
func exploded(r: int, c: int):
	set_cell(Vector2i(c, r), ATLAS_ID, EXPLODED_MINE_TILE)
			
func mine_revealed(r: int, c: int):
	set_cell(Vector2i(c, r), ATLAS_ID, MINE_TILE)
	
func number_revealed(r: int, c: int, count: int):
	var atlas_x = count%10
	
	# Shift down based on the row where zero is
	var atlas_y = count/10 + ZERO_ROW
	
	# If we get a negative mod, that's because the number is less than
	# zero. Need to go one before the zero-row, and
	if atlas_x < 0:
		if(count < -9):
			atlas_x = 0
		else:
			atlas_x = atlas_x + 10
		atlas_y = ZERO_ROW - 1
	
	set_cell(Vector2i(c, r), ATLAS_ID, Vector2i(atlas_x, atlas_y))
	
func blank_revealed(r: int, c: int):
	set_cell(Vector2i(c, r), ATLAS_ID, BLANK)
	
func adjacent_unindicate_all():
	for r in range(rows):
		for c in range(cols):
			
			# Retrieved in order x, y
			var atlas_coords = get_cell_atlas_coords(Vector2i(c, r))
			if atlas_coords == ADJACENT:
				set_cell(Vector2i(c, r), 0, HIDDEN)
				
func adjacent_indicate(r: int, c: int):
		var atlas_coords = get_cell_atlas_coords(Vector2i(c, r))
		if atlas_coords == HIDDEN:
			set_cell(Vector2i(c, r), 0, ADJACENT)
	
			
	
	
	

	
	
func _input(event: InputEvent):
	
	if event is InputEventKey:
		var mouse_pos: Vector2 = get_local_mouse_position()
		if(in_local_bounds(mouse_pos)):
			update_mouse_position(mouse_pos)
	
		return
		
		
	if not (event is InputEventMouseButton or event is InputEventMouseMotion):
		return
	
	if lost:
		return
	
	
	event = make_input_local(event)
	if not in_local_bounds(event.position):
		return
	
	if event is InputEventMouseMotion:
		update_mouse_position(event.position)
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		right_button_click(event)
	elif event.button_index == MOUSE_BUTTON_LEFT:
		left_button_click(event)
		

func update_mouse_position(position: Vector2):
	var map_loc: Vector2i = local_to_map(position)
	# Emit in form r, c
	square_entered.emit(map_loc.y, map_loc.x)
	
	

func left_button_click(event: InputEvent):
	if event.pressed:
		return
		
	var map_loc: Vector2i = local_to_map(event.position)
	
	# Emit in form r, c
	clicked.emit(map_loc.y, map_loc.x)
		

func right_button_click(event:InputEvent):
	# Only responding to mouse-release events
	if event.pressed:
		return
		
	var map_loc: Vector2i = local_to_map(event.position)
	
	var atlas_coords: Vector2i = get_cell_atlas_coords(map_loc)
	
	if atlas_coords == FLAGGED:
		set_cell(map_loc, ATLAS_ID, QUESTIONED)
		flag_changed.emit(map_loc.y, map_loc.x, Consts.QUESTIONED_STATE)
	elif atlas_coords == QUESTIONED:
		set_cell(map_loc, ATLAS_ID, HIDDEN)
		flag_changed.emit(map_loc.y, map_loc.x, Consts.NO_FLAG_STATE)
	elif atlas_coords == HIDDEN:
		set_cell(map_loc, ATLAS_ID, FLAGGED)
		flag_changed.emit(map_loc.y, map_loc.x, Consts.FLAG_STATE)
		
	pass
	
func is_hidden(r: int, c: int) -> bool:
	
	var atlas_coords: Vector2i = get_cell_atlas_coords(Vector2i(c, r))
	if atlas_coords == FLAGGED:
		return true
	elif atlas_coords == HIDDEN:
		return true
	elif atlas_coords == QUESTIONED:
		return true
		
	return false
	
func in_map_bounds(r: int, c: int) -> bool:
	if c < cols and c >= 0:
		if r < rows and r >= 0:
			return true
			
	return false
	
	
func in_local_bounds(position: Vector2) -> bool:
	var map_pos: Vector2i = local_to_map(position)
	if map_pos.x < cols and map_pos.x >= 0:
		if map_pos.y < rows and map_pos.y >= 0:
			return true
			
	return false
	
func lose():
	lost = true
