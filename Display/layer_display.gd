extends TileMapLayer

var rows: int
var cols: int 


var EMPTY_TILE: Vector2i = Vector2i(0, 0)
var MINE_TILE: Vector2i = Vector2i(3, 2)


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
			set_cell(Vector2i(c, r), atlas_ID, EMPTY_TILE)
			pass
			
func mine_added(r: int, c: int):
	var atlas_ID = 0
	set_cell(Vector2i(c, r), atlas_ID, MINE_TILE)
	

	
	
func _input(event: InputEvent):
	if not event is InputEventMouseButton:
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
