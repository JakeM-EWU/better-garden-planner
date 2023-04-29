extends Panel

# Declare the custom signal with the desired arguments.
signal dimensions_selected(x_dimension, y_dimension)

# Declare the sliders and spin boxes as onready variables so they are available as soon as the node is in the scene tree.
@onready var x_slider = $VBoxContainer/DimensionsContainer/XDimensionSlider
@onready var x_spin_box = $VBoxContainer/DimensionsContainer/XDimensionSpinBox
@onready var y_slider = $VBoxContainer/YDimensionsContainer/YDimensionSlider
@onready var y_spin_box = $VBoxContainer/YDimensionsContainer/YDimensionSpinBox
@onready var create_button = $CreateButton


# Function called when the x_slider value changes.
func on_x_slider_change(value):
	# Update the x_spin_box value to match the x_slider value.
	x_spin_box.value = value

# Function called when the y_slider value changes.
func on_y_slider_change(value):
	# Update the y_spin_box value to match the y_slider value.
	y_spin_box.value = value

# Function called when the x_spin_box value changes.
func on_x_spin_box_change(value):
	# Update the x_slider value to match the x_spin_box value.
	x_slider.value = value

# Function called when the y_spin_box value changes.
func on_y_spin_box_change(value):
	# Update the y_slider value to match the y_spin_box value.
	y_slider.value = value
	
func on_create_button_pressed():
	# Check if values are valid, arbitrarily 1-100.
	if x_slider.value >= 1 and x_slider.value <= 100 and y_slider.value >= 1 and y_slider.value <= 100:
		# Emit the custom signal with the selected x and y dimensions.
		emit_signal("dimensions_selected", x_slider.value, y_slider.value)
	# TODO: add an else with an error message
	
#this is for testing
#func _ready():
#	self.dimensions_selected.connect(self.on_dimensions_selected)
#func on_dimensions_selected(x,y):
#	print("X:",x,"Y:",y)
