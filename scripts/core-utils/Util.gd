extends Object
class_name Util

## Get rotation in rad for rotating towards a given point.
static func get_rotation_linear(from: float, to: float, speed: float, delta: float) -> float:
    var diff: float = wrapf(to - from, -PI, PI)
    
    # prevent overshooting
    if abs(diff) <= speed * delta:
        return to

    return from + sign(diff) * speed * delta
    
## Get formatted time from msec.
static func format_time(time: int, include_msec: bool = false) -> String:
    var hours: int = time / 3600000
    var minutes: int = (time % 3600000) / 60000
    var seconds: int = (time % 60000) / 1000
    var msec: int = time % 1000
    
    var format_mask: String = '%02d:%02d:%02d.%03d'
    var retval: String
    
    if include_msec:
        format_mask = '%02d:%02d:%02d.%03d'
        retval = format_mask % [hours, minutes, seconds, msec]
    else:
        format_mask = '%02d:%02d:%02d'
        retval = format_mask % [hours, minutes, seconds, msec]
        
    return retval

static func get_uptime_formatted() -> String:
    return format_time(Time.get_ticks_msec(), true)
    
    
static func to_msec(seconds: float) -> float:
    return seconds * 1_000.0

static func to_usec(seconds: float) -> float:
    return seconds * 1_000_000.0

static func nvl(value: Variant, fallback: Variant) -> Variant:
    return value if value != null else fallback

static func has_property(obj: Object, prop_name: String) -> bool:
    for p: Dictionary in obj.get_property_list():
        if p.name == prop_name:
            return true
    return false

static func make_3point_gradient(
    start: Color,
    middle: Color,
    end: Color,
    start_alpha: float = 1.0,
    middle_alpha: float = 0.5,
    end_alpha: float = 0.0
) -> Gradient:
    var s: Color = start
    var m: Color = middle
    var e: Color = end

    s.a = start_alpha
    m.a = middle_alpha
    e.a = end_alpha

    var g: Gradient = Gradient.new()
    g.offsets = PackedFloat32Array([0.0, 0.5, 1.0])
    g.colors = PackedColorArray([s, m, e])

    return g

static func on_off(val: bool) -> String:
    if val:
        return "on"
    else:
        return "off"
        
static func true_false(val: bool) -> String:
    if val:
        return "true"
    else:
        return "false"
        
static func enabled_disabled(val: bool) -> String:
    if val:
        return "enabled"
    else:
        return "disabled"

static func get_vector(p_negative_x: StringName, p_positive_x: StringName, p_negative_y: StringName, p_positive_y: StringName) -> Vector2:
    return Vector2(Input.get_axis(p_negative_x, p_positive_x), Input.get_axis(p_negative_y, p_positive_y)).limit_length(1.0)
        
static func change_scene(path: String) -> void:
    var root = GlobalRef.get_root()
    
    for child in root.get_children():
        child.queue_free()
    
    await root.get_tree().process_frame
    
    root.add_child(load(path).instantiate())
        
        
        
        
        
        
        
        
        
        
        
        
        
