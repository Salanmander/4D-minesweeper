extends TileMapLayer

var rows: int
var cols: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func set_dimensions(rows: int, cols: int):
	self.rows = rows
	self.cols = cols

func clear_all():
	clear()
	
func highlight(r: int, c:int, hidden: bool):
	if hidden:
		set_cell(Vector2i(c, r), 0, Vector2i(0, 0))
	else:
		set_cell(Vector2i(c, r), 0, Vector2i(1, 0))
		

func entered_nearby_layer(r: int, c: int):
	clear()
	
	# Find adjacent squares
	var r_checks: Array[int] = []
	var c_checks: Array[int] = []
	for off in [-1, 0, 1]:
		if r + off >= 0 and r + off < rows:
			r_checks.append(r + off)
		if c + off >= 0 and c + off < cols:
			c_checks.append(c + off)
		pass
		
	for row in r_checks:
		for col in c_checks:
			set_cell(Vector2i(col, row), 0, Vector2i(1, 0))
