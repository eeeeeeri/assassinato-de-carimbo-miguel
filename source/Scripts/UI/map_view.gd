extends SubViewportContainer

@export var angle_x_max = 15.0
@export var angle_y_max = 15.0

func _ready() -> void:
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)

func _on_gui_input(event: InputEvent) -> void:
	
	var mouse_pos : Vector2 = get_local_mouse_position()
	
	var lerp_val_x : float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y : float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	var rot_x : float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y : float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	
	material.set_shader_parameter("x_rot", rot_y)
	material.set_shader_parameter("y_rot", rot_x)
