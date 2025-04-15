extends TileMapLayer

var rows: int
var cols: int 

var lost: bool


var EMPTY_TILE: Vector2i = Vector2i(0, 0)
var HIDDEN: Vector2i = Vector2i(1, 2)
var MINE_TILE: Vector2i = Vector2i(3, 2)
var EXPLODED_MINE_TILE: Vector2i = Vector2i(2, 2)


signal clicked(r: int, c: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func set_dimensions(rows: int, cols: int):
	clear()
	self.rows = rows
	self.cols = cols
	for r in range(rows):
		for c in range(cols):
			var atlas_ID = 0
			set_cell(Vector2i(c, r), atlas_ID, HIDDEN)
			pass
			
func exploded(r: int, c: int):
	var atlas_ID = 0
	set_cell(Vector2i(c, r), atlas_ID, EXPLODED_MINE_TILE)
			
func mine_revealed(r: int, c: int):
	var atlas_ID = 0
	set_cell(Vector2i(c, r), atlas_ID, MINE_TILE)
	
func number_revealed(r: int, c: int, count: int):
	var atlas_ID = 0
	var atlas_x = count%10
	var atlas_y = count/10
	set_cell(Vector2i(c, r), atlas_ID, Vector2i(atlas_x, atlas_y))
	
	

	
	
func _input(event: InputEvent):
	if not event is InputEventMouseButton:
		return
	
	if lost:
		return
		
		
	event = make_input_local(event)
	if not in_local_bounds(event.position):
		return
		
	# Only responding to mouse-release events
	if event.pressed:
		return
		
	var map_loc: Vector2i = local_to_map(event.position)
	
	# Emit in form r, c
	clicked.emit(map_loc.y, map_loc.x)
	
func in_local_bounds(position: Vector2) -> bool:
	var map_pos: Vector2i = local_to_map(position)
	if map_pos.x < cols and map_pos.x >= 0:
		if map_pos.y < rows and map_pos.y >= 0:
			return true
			
	return false
	
func lose():
	lost = true
