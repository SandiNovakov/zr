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
