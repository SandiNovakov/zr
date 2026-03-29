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

func _ready() -> void:
    if get_parent() is not Node2D:
        Syslog.error("Node Trail2D: %s expected Node2D parent, got %s instead!" % [self, get_parent().get_class()])
    
    parent = get_parent()
    top_level = true
    
    if use_gradient:
        
        if not gradient:
            gradient = Gradient.new()

        gradient.add_point(0, Util.nvl(Pallete.get_color(color_start), default_color_start))
        gradient.add_point(0.5, Util.nvl(Pallete.get_color(color_middle), default_color_middle))
        gradient.add_point(1, Util.nvl(Pallete.get_color(color_end), default_color_end))

func _physics_process(delta: float) -> void:
    queue.push_front(parent.position)
    
    if queue.size() > max_length:
        queue.pop_back()
    
    clear_points()
    
    for point: Vector2 in queue:
        add_point(point)
