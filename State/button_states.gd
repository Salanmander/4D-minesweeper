extends Node

var left_held: bool = false
var right_held: bool = false
var c_held: bool = false

var two_release_start_time: int = 0
var right_release_time: int = 0
var left_release_time: int = 0

# number of milliseconds between button releases that makes it qualify as a
# two-button-click
const two_button_click_time: int = 100

#signal two_button_press_started(event: InputEventMouseButton)
#signal two_button_press_ended(event: InputEventMouseButton)
signal two_button_click(event: InputEventMouseButton)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func c_down(event: InputEventKey):
	c_held = true
	
func c_up(event: InputEventKey):
	c_held = false

func left_button_down(event: InputEventMouseButton):
	left_held = true
	if(right_held):
		#two_button_press_started.emit(event)
		pass


func left_button_up(event: InputEventMouseButton):
	left_held = false
	left_release_time = Time.get_ticks_msec()
	if(right_held):
		two_release_start_time = Time.get_ticks_msec()
	else:
		var two_release_end_time = Time.get_ticks_msec()
		if two_release_end_time - two_release_start_time < two_button_click_time:
			two_button_click.emit(event)
			
		
func right_button_down(event: InputEventMouseButton):
	right_held = true
	if(left_held):
		#two_button_press_started.emit(event)
		pass


func right_button_up(event: InputEventMouseButton):
	right_held = false
	right_release_time = Time.get_ticks_msec()
	if(left_held):
		two_release_start_time = Time.get_ticks_msec()
	else:
		var two_release_end_time = Time.get_ticks_msec()
		if two_release_end_time - two_release_start_time < two_button_click_time:
			two_button_click.emit(event)
			
func msec_since_left_release() -> int:
	return Time.get_ticks_msec() - left_release_time
	
	
func msec_since_right_release() -> int:
	return Time.get_ticks_msec() - right_release_time
		
