extends Node2D

@onready var land_material: ShaderMaterial = $sprite.get_material()

var sun_distance: float = 1.5
var isometric_shadows: bool = false
var mouse_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	%SunDistanceSlider.set_value(sun_distance)
	%SunDistanceValue.set_text(str(sun_distance))
	%IsometricShadowsToggle.button_pressed = isometric_shadows


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var sun_position: Vector2
	
	if (isometric_shadows):
		sun_position = Vector2(
			(mouse_position.x / get_viewport_rect().size.x) - 0.5,
			(mouse_position.y / get_viewport_rect().size.y) - 0.5,
		)
	else:
		sun_position = Vector2(
			mouse_position.x / get_viewport_rect().size.x,
			mouse_position.y / get_viewport_rect().size.y
		)
	
	land_material.set_shader_parameter("sunPos", Vector3(sun_position.x, sun_position.y, sun_distance))
	%SunPositionValue.set_text("x: " + ("%.2f" % sun_position.x) + " | y:" + ("%.2f" % sun_position.y))


func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position

func _on_isometric_shadows_toggle_toggled(toggled_on):
	isometric_shadows = toggled_on
	land_material.set_shader_parameter("isometricShadows", toggled_on)


func _on_sun_distance_slider_value_changed(value):
	sun_distance = value
	%SunDistanceValue.set_text(str(value))
