extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func set_label(text: String):
	$Label.text = text
	
func set_val(val: int):
	$SpinBox.value = val

func get_val() -> int:
	return $SpinBox.value
