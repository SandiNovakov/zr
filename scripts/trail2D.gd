@warning_ignore_start("inferred_declaration")
extends Line2D
class_name Trail2D

var queue: Array
var parent: Node2D

@export var max_length: int
@export_category("Gradient")
@export var use_gradient: bool

##Reference to the `Pallete.color` to be used for the starting color of the trail.
@export var color_start: Pallete.Colors

##Reference to the `Pallete.color` to be used for the middle color of the trail.
@export var color_middle: Pallete.Colors

##Reference to the `Pallete.color` to be used for the ending color of the trail.
@export var color_end: Pallete.Colors

var default_color_start: Color = Color.WHITE
var default_color_middle: Color = Color.from_rgba8(127, 127, 127, 255)
var default_color_end: Color = Color.from_rgba8(0, 0, 0, 255)

var prev_pos: Vector2
var curr_pos: Vector2

func _ready() -> void:
    if get_parent() is not Node2D:
        Syslog.error("Node Trail2D: %s expected Node2D parent, got %s instead!" % [self, get_parent().get_class()])
    
    parent = get_parent()
    top_level = true
    
    if use_gradient:

        var color_start_value: Color = Util.nvl(Pallete.get_color(color_start), default_color_start)
        var color_middle_value: Color = Util.nvl(Pallete.get_color(color_middle), default_color_middle)
        var color_end_value: Color = Util.nvl(Pallete.get_color(color_end), default_color_end)

        color_start_value.a = 1
        color_middle_value.a = 0.5
        color_end_value.a = 0

        var gradient_data := {
            0.0: color_start_value,
            0.5: color_middle_value,
            1.0: color_end_value
        }

        gradient = Gradient.new()
        gradient.offsets = gradient_data.keys()
        gradient.colors = gradient_data.values() 

    prev_pos = parent.position
    curr_pos = parent.position

func _physics_process(delta: float) -> void:
    prev_pos = curr_pos
    curr_pos = parent.position

func _process(delta: float) -> void:
    var alpha := Engine.get_physics_interpolation_fraction()
    var interpolated_pos := prev_pos.lerp(curr_pos, alpha)
    
    queue.push_front(interpolated_pos)
    
    if queue.size() > max_length:
        queue.pop_back()
    
    clear_points()
    
    for point: Vector2 in queue:
        add_point(point)
