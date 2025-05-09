extends Resource
class_name Mine4D




# grid ends up being a 4D array of Dictionary objects.
# Each dict has the following keys:
#  mine: bool - whether the square has a mine
#  adjacent: int - number of mines adjacent to that square
#  flags_adjacent: int - number of flags adjacent to that square
#  revealed: bool - whether the square has been revealed
#  flag_state: int - a number indicating whether the square has
#       been flagged. Has possible values:
#       Consts.NO_FLAG_STATE
#       Consts.FLAG_STATE
#       Consts.QUESTIONED_STATE
var grid: Array



var big_rows: int
var big_cols: int
var rows: int
var cols: int

var display_diff: bool
var game_running: bool
var victory: bool

signal save_requested()
signal game_won()
signal exploded(big_r: int, big_c: int, r: int, c:int)
signal mine_revealed(big_r: int, big_c: int, r: int, c:int)
signal nomine_revealed(big_r: int, big_c: int, r: int, c: int)
signal number_revealed(big_r: int, big_c: int, r: int, c:int, count: int)
signal blank_revealed(big_r: int, big_c: int, r: int, c:int)
signal flag_loaded(big_r: int, big_c: int, r: int, c: int, flag_state: int)

func _init(big_rows: int = 5, big_cols: int = 5, rows: int = 8, cols: int = 8, mines: int = 0):
	
	self.big_rows = big_rows
	self.big_cols = big_cols
	self.rows = rows
	self.cols = cols
	display_diff = true
	game_running = true
	victory = false
	
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
					row.append(get_default_grid_info())
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
	var this_spot: Dictionary = grid[big_r][big_c][r][c]
	
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
	


func flood_open(big_r: int, big_c: int, r: int, c: int):
	
	#var start_time = Time.get_ticks_usec()
	var queue: Array[Array] = []
	
	# Reveal and emit before we add to the queue. The queue is for
	# what things we should reveal the neighbors of
	reveal_space(big_r, big_c, r, c)
	
	if grid[big_r][big_c][r][c].adjacent - grid[big_r][big_c][r][c].flags_adjacent  != 0:
		return
		
	# If the number *was* zero, queue to reveal neighbors
	
	queue.append([big_r, big_c, r, c])
	
	var max_queue_size: int = queue.size()
	
	while queue.size() > 0:
		var coords: Array = queue.pop_front()
		big_r = coords[0]
		big_c = coords[1]
		r = coords[2]
		c = coords[3]
		
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
							var space = grid[ch_br][ch_bc][ch_r][ch_c]
							if (not space.revealed) and space.flag_state == Consts.NO_FLAG_STATE:
								reveal_space(ch_br, ch_bc, ch_r, ch_c)
								var delta: int = space.adjacent
								delta -= space.flags_adjacent
								if delta == 0:
									queue.append([ch_br, ch_bc, ch_r, ch_c])
								
		if queue.size() > max_queue_size:
			max_queue_size = queue.size()
			
	# This is necessary because while things are being revealed, they
	# will still have hidden spaces next to them. Afterwards, we need to go
	# back and check all the revealed spaces and make them blanks
	# if they should be
	do_for_all(update_display_num)
	check_victory()
	
	#var end_time = Time.get_ticks_usec()
	#print((end_time - start_time)/1000)
	
func reveal_space(big_r: int, big_c: int, r: int, c: int):
	var space: Dictionary = grid[big_r][big_c][r][c]
	space.revealed = true
	
	
	var display_amount = space.adjacent
	if(display_diff):
		display_amount -= space.flags_adjacent

	if space.mine:
		explode(big_r, big_c, r, c)
	elif display_amount == 0 and not has_adjacent_hidden_nonflag(big_r, big_c, r, c):
		blank_revealed.emit(big_r, big_c, r, c)
	else:
		number_revealed.emit(big_r, big_c, r, c, display_amount)


func check_victory():
	victory = true
	do_for_all(prevent_victory)
	if victory:
		game_won.emit()
		
func prevent_victory(big_r: int, big_c: int, r: int, c: int):
	var space: Dictionary = grid[big_r][big_c][r][c]
	if space.mine and (not space.flag_state == Consts.FLAG_STATE):
		victory = false
	if (not space.mine) and (not space.revealed):
		victory = false
	

func explode(big_r: int, big_c: int, r: int, c: int):
	game_running = false
	grid[big_r][big_c][r][c].revealed = true
	exploded.emit(big_r, big_c, r, c)
	do_for_all(reveal_mine)
	pass
	
func reveal_mine(big_r: int, big_c: int, r: int, c:int):
	var space: Dictionary = grid[big_r][big_c][r][c]
	if not space.mine:
		var flagged: bool = space.flag_state == Consts.FLAG_STATE
		var questioned: bool = space.flag_state == Consts.QUESTIONED_STATE
		if flagged or questioned:
			space.revealed = true
			nomine_revealed.emit(big_r, big_c, r, c)
		return
	
	if space.revealed:
		return
	
	grid[big_r][big_c][r][c].revealed = true
	mine_revealed.emit(big_r, big_c, r, c)
	
func update_display_full(big_r: int, big_c: int, r: int, c: int):
	update_display_num(big_r, big_c, r, c)
	var space = grid[big_r][big_c][r][c]
	if not space.revealed:
		if space.flag_state == Consts.FLAG_STATE:
			flag_loaded.emit(big_r, big_c, r, c, Consts.FLAG_STATE)
		if space.flag_state == Consts.QUESTIONED_STATE:
			flag_loaded.emit(big_r, big_c, r, c, Consts.QUESTIONED_STATE)


func update_display_num(big_r: int, big_c: int, r: int, c: int):
	var space = grid[big_r][big_c][r][c]
	if not space.revealed:
		return
	
	# Need to avoid turning revealed mines into numbers
	if space.mine:
		return
	
	var display_amount = space.adjacent
	if(display_diff):
		display_amount -= space.flags_adjacent
	
	
	if display_amount == 0 and not has_adjacent_hidden_nonflag(big_r, big_c, r, c):
		blank_revealed.emit(big_r, big_c, r, c)
	else:
		number_revealed.emit(big_r, big_c, r, c, display_amount)

	
func has_adjacent_hidden_nonflag(big_r: int, big_c: int, r: int, c: int) -> bool:

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
	

	for ch_br in br_checks:
		for ch_bc in bc_checks:
			for ch_r in r_checks:
				for ch_c in c_checks:
					if (ch_br != big_r or ch_bc != big_c or ch_r != r or ch_c != c):
						if not grid[ch_br][ch_bc][ch_r][ch_c].revealed:
							if not grid[ch_br][ch_bc][ch_r][ch_c].flag_state == Consts.FLAG_STATE:
								return true
	
	return false
	
	

#region from_display

func display_diff_changed(display_diff: bool):
	self.display_diff = display_diff
	do_for_all(update_display_num)
	

# The order of inputs here is different because big_r and big_c are from a 
# bindv, since they're connected to signals from various different objects
func on_click(r: int, c: int, big_r: int, big_c: int):
	if grid[big_r][big_c][r][c].flag_state != Consts.NO_FLAG_STATE:
		return
	if grid[big_r][big_c][r][c].mine:
		explode(big_r, big_c, r, c)
		return
	
	flood_open(big_r, big_c, r, c)
	if game_running:
		save_requested.emit()
	

func on_adjacent_check(r: int, c: int, big_r: int, big_c: int):
	if grid[big_r][big_c][r][c].adjacent != grid[big_r][big_c][r][c].flags_adjacent:
		return
	
	flood_open(big_r, big_c, r, c)
	if game_running:
		save_requested.emit()
	
func flag_changed(r: int, c: int, flagged: int, big_r: int, big_c: int):
	grid[big_r][big_c][r][c].flag_state = flagged
	
	# Change surrounding adjacent-flag counts by 1 if went to flagged
	# or to questioned
	var delta: int = 0
	if flagged == Consts.FLAG_STATE:
		delta = 1
	if flagged == Consts.QUESTIONED_STATE:
		delta = -1
		
	
	# Find adjacent squares
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
		
	# Change flag count of adjacent squares
	for ch_br in br_checks:
		for ch_bc in bc_checks:
			for ch_r in r_checks:
				for ch_c in c_checks:
					if (ch_br != big_r or ch_bc != big_c or ch_r != r or ch_c != c):
						grid[ch_br][ch_bc][ch_r][ch_c].flags_adjacent += delta
						if grid[ch_br][ch_bc][ch_r][ch_c].revealed:
							reveal_space(ch_br, ch_bc, ch_r, ch_c)
	
	if game_running:
		save_requested.emit()
		
	
	
#endregion

#region saveAndLoad

func get_grid() -> Array:
	return grid
	

func load_data_from_grid(saved_grid: Array):
	grid = saved_grid
	do_for_all(update_display_full)
	

#endregion

	
func get_default_grid_info() -> Dictionary:
	var grid_info: Dictionary = {}
	grid_info.mine = false
	grid_info.adjacent = 0
	grid_info.flags_adjacent= 0
	grid_info.revealed = false
	grid_info.flag_state = Consts.NO_FLAG_STATE
	
	return grid_info

	
	
