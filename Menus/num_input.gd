extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func set_label(text: String):
	$Label.text = text
	
func set_val(val: int):
	$SpinBox.value = val
	
func set_max_val(max_val: int):
	$SpinBox.max_value = max_val

func get_val() -> int:
	return $SpinBox.value
