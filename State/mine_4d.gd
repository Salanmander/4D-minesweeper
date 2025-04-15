extends Resource
class_name Mine4D

var grid: Array
var big_rows: int
var big_cols: int
var rows: int
var cols: int

signal exploded(big_r: int, big_c: int, r: int, c:int)
signal mine_revealed(big_r: int, big_c: int, r: int, c:int)
signal number_revealed(big_r: int, big_c: int, r: int, c:int, count: int)

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
			mines -= 1
		
		pass
	
	pass
	
func calc_all_adjacent():
	do_for_all(calc_adjacent_count)
	
func do_for_all(to_call: Callable):
	#var start:int = Time.get_ticks_usec()
	for br in range(big_rows):
		for bc in range(big_cols):
			for r in range(rows):
				for c in range(cols):
					to_call.call(br, bc, r, c)
	
	#var end:int = Time.get_ticks_usec()
	#print((end-start)/1000)
					

func calc_adjacent_count(big_r: int, big_c: int, r: int, c: int):
	var this_spot: GridInfo = grid[big_r][big_c][r][c]
	
	if this_spot.mine:
		return
	
	var br_checks: Array[int] = []
	var bc_checks: Array[int] = []
	var r_checks: Array[int] = []
	var c_checks: Array[int] = []
	for off in [-1, 0, 1]:
		if big_r + off >= 0 and big_r + off < big_rows:
			br_checks.append(big_r + off)
		if big_c + off >= 0 and big_c + off < big_cols:
			bc_checks.append(big_c + off)
		if r + off >= 0 and r + off < rows:
			r_checks.append(r + off)
		if c + off >= 0 and c + off < cols:
			c_checks.append(c + off)
		pass
	
	var adjacent_count: int = 0
	for ch_br in br_checks:
		for ch_bc in bc_checks:
			for ch_r in r_checks:
				for ch_c in c_checks:
					if (ch_br != big_r or ch_bc != big_c or ch_r != r or ch_c != c):
						if grid[ch_br][ch_bc][ch_r][ch_c].mine:
							adjacent_count += 1
							
	this_spot.adjacent = adjacent_count

func set_mine(big_r: int, big_c: int, r: int, c: int, val: bool):
	grid[big_r][big_c][r][c].mine = val
	pass
	
func is_mine(big_r: int, big_c: int, r: int, c: int) -> bool:
	return grid[big_r][big_c][r][c].mine
	
# The order of inputs here is different because big_r and big_c are from a 
# bindv, since they're connected to signals from various different objects
func on_click(r: int, c: int, big_r: int, big_c: int):
	if grid[big_r][big_c][r][c].mine:
		explode(big_r, big_c, r, c)
		return
	
	flood_open(big_r, big_c, r, c)


func flood_open(big_r: int, big_c: int, r: int, c: int):
	number_revealed.emit(big_r, big_c, r, c, grid[big_r][big_c][r][c].adjacent)
	grid[big_r][big_c][r][c].revealed = true
	
	
	if grid[big_r][big_c][r][c].adjacent != 0:
		return
	
	# If the number *was* zero, continue by recursively opening nearby things
	
	var br_checks: Array[int] = []
	var bc_checks: Array[int] = []
	var r_checks: Array[int] = []
	var c_checks: Array[int] = []
	for off in [-1, 0, 1]:
		if big_r + off >= 0 and big_r + off < big_rows:
			br_checks.append(big_r + off)
		if big_c + off >= 0 and big_c + off < big_cols:
			bc_checks.append(big_c + off)
		if r + off >= 0 and r + off < rows:
			r_checks.append(r + off)
		if c + off >= 0 and c + off < cols:
			c_checks.append(c + off)
		pass
		
	# Recursive call for any not-yet-revealed adjacent squares
	for ch_br in br_checks:
		for ch_bc in bc_checks:
			for ch_r in r_checks:
				for ch_c in c_checks:
					if (ch_br != big_r or ch_bc != big_c or ch_r != r or ch_c != c):
						if not grid[ch_br][ch_bc][ch_r][ch_c].revealed:
							flood_open(ch_br, ch_bc, ch_r, ch_c)
	

func explode(big_r: int, big_c: int, r: int, c: int):
	grid[big_r][big_c][r][c].revealed = true
	exploded.emit(big_r, big_c, r, c)
	do_for_all(reveal_mine)
	pass
	
func reveal_mine(big_r: int, big_c: int, r: int, c:int):
	if not grid[big_r][big_c][r][c].mine:
		return
	
	if grid[big_r][big_c][r][c].revealed:
		return
	
	grid[big_r][big_c][r][c].revealed = true
	mine_revealed.emit(big_r, big_c, r, c)
	
class GridInfo:
	var mine: bool = false
	var adjacent: int = 0
	var revealed: bool = false
	var flagged: bool = false
	
	
