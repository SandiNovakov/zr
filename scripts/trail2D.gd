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
var default_color_middle: Color = Color.from_rgba8(127, 127, 127, 127)
var default_color_end: Color = Color.from_rgba8(0, 0, 0, 0)

var prev_pos: Vector2
var curr_pos: Vector2

func _ready() -> void:
    if get_parent() is not Node2D:
        Syslog.error("Node Trail2D: %s expected Node2D parent, got %s instead!" % [self, get_parent().get_class()])
    
    parent = get_parent()
    top_level = true
    
    if use_gradient:

        var gradient_data := {
            0.0: Util.nvl(Pallete.get_color(color_start), default_color_start),
            0.5: Util.nvl(Pallete.get_color(color_middle), default_color_middle),
            1.0: Util.nvl(Pallete.get_color(color_end), default_color_end)
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
