extends Resource
class_name Mine4D

var grid: Array

func _init(big_rows: int = 5, big_cols: int = 5, rows: int = 8, cols: int = 8, mines: int = 30):
	
	make_grid(big_rows, big_cols, rows, cols)
	add_mines(mines)
	
	
func make_grid(big_rows: int, big_cols: int, rows: int, cols: int):
	grid = []
	for br in range(big_rows):
		# make a stack
		var stack: Array = []
		
		# add each layer to the stack
		for bc in range(big_cols):
			# make a layer
			var layer: Array = []
			# add each row to the layer
			for r in range(rows):
				# make a row
				var row: Array = [];
				# fill row with GridInfos
				for c in range(cols):
					row.append(GridInfo.new())
				layer.append(row)
			# Done forming layer
		
			stack.append(layer)
		
		#Done forming stack
		
		grid.append(stack)
				
	pass
	
func add_mines(mines: int):
	
	pass
	

func set_mine(big_r: int, big_c: int, r: int, c: int, val: bool):
	grid[big_r][big_c][r][c].mine = val
	pass
	
func is_mine(big_r: int, big_c: int, r: int, c: int) -> bool:
	return grid[big_r][big_c][r][c].mine
	
	
class GridInfo:
	var mine: bool = false
	var adjacent: int = 0
	var revealed: bool = false
	var flagged: bool = false
	
	
