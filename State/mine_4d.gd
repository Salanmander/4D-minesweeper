extends Resource
class_name Mine4D

var grid: Array
var big_rows: int
var big_cols: int
var rows: int
var cols: int

signal mine_added(big_r: int, big_c: int, r: int, c:int)

func _init(big_rows: int = 5, big_cols: int = 5, rows: int = 8, cols: int = 8, mines: int = 0):
	
	self.big_rows = big_rows
	self.big_cols = big_cols
	self.rows = rows
	self.cols = cols
	make_grid()
	add_mines(mines)
	
	
func make_grid():
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
	
	while(mines > 0):
		
		var big_r = randi_range(0,big_rows-1)
		var big_c = randi_range(0,big_cols-1)
		var r = randi_range(0,rows-1)
		var c = randi_range(0,cols-1)
		
		if(!is_mine(big_r, big_c, r, c)):
			set_mine(big_r, big_c, r, c, true)
			mine_added.emit(big_r, big_c, r, c)
			mines -= 1
		
		pass
	
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
	
	
