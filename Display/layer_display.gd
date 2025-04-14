extends TileMapLayer

var rows: int
var cols: int 


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
			var empty_tile = Vector2i(0, 0)
			set_cell(Vector2i(c, r), atlas_ID, empty_tile)
			pass

# Temporary, will use signals
func display_mines(mines_grid: Array):
	for r in rows:
		for c in cols:
			if mines_grid[r][c]:
				var atlas_ID = 0
				var mine_tile = Vector2i(3, 2)
				set_cell(Vector2i(c, r), atlas_ID, mine_tile )
	
	
func _input(event: InputEvent):
	if event is InputEventMouseButton:
		event = make_input_local(event)
		if in_local_bounds(event.position):
			print(event.position)
	pass
	
func in_local_bounds(position: Vector2) -> bool:
	var map_pos: Vector2i = local_to_map(position)
	if map_pos.x < cols and map_pos.x >= 0:
		if map_pos.y < rows and map_pos.y >= 0:
			return true
			
	return false
