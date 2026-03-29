extends Node

var id_serial: int = 0
var rumble_weak_str: float = 0.0
var rumble_strong_str: float = 0.0


class Rumble:
    func _init(p_id: int, p_weak_str: float, p_strong_str: float, p_duration: float) -> void:
        id = str(p_id)
        weak_str = p_weak_str
        strong_str = p_strong_str
        duration = p_duration
        
        if p_duration == 0:
            lifetime = INF
        else:
            lifetime = p_duration
        
    var id: String
    var weak_str: float
    var strong_str: float
    var duration: float
    var lifetime: float

var rumbles: Array[Rumble]

func add(weak_str: float, strong_str: float, duration: float) -> void:
    rumbles.append(
        Rumble.new(
            _get_id(),
            weak_str,
            strong_str,
            duration,
        )
    )
        
func start(weak_str: float, strong_str: float) -> String:
    var new_id: int = _get_id()
    
    rumbles.append(
        Rumble.new(
            new_id,
            weak_str,
            strong_str,
            0
        )
    )    
    
    return str(new_id)
    
func end(id: String) -> void:
    for rumble: Rumble in rumbles:
        if rumble.id == id:
            rumbles.erase(rumble)
            return
            
    Syslog.error("Called for stop of vibration %s but such vibration doesn't exist or already stopped." % [id])
    
func _get_id() -> int:
    var retval: int = id_serial
    id_serial += 1
    return retval

func _get_max_weak() -> float:
    var retval: float = 0.0
    for r: Rumble in rumbles:
        retval = max(retval, r.weak_str)
    return retval

func _get_max_strong() -> float:
    var retval: float = 0.0
    for r: Rumble in rumbles:
        retval = max(retval, r.strong_str)
    return retval

func _update_rumbles(delta: float) -> void:
    for i in range(rumbles.size() -1, -1, -1):
        var rumble: Rumble = rumbles[i]
        if rumble.lifetime != INF:
            rumble.lifetime -= delta
            
            if rumble.lifetime <= 0:
                rumbles.remove_at(i)


func _physics_process(delta: float) -> void:
    _update_rumbles(delta)
    
    #if InputDeviceManager.current_input_device != InputDeviceManager.InputDevices.CONTROLLER:
        #if Input.get_joy_vibration_strength(0) != Vector2.ZERO:
            #Input.stop_joy_vibration(0)
            #rumble_strong_str = 0
            #rumble_weak_str = 0
        #
        #return
    
    var max_strong_str: float = _get_max_strong()
    var max_weak_str: float = _get_max_weak()
    
    if max_strong_str != rumble_strong_str or max_weak_str != rumble_weak_str:
        rumble_strong_str = max_strong_str
        rumble_weak_str = max_weak_str
        
        if rumble_strong_str == 0.0 and rumble_weak_str == 0.0:
            Input.stop_joy_vibration(0)
        else:
            Input.start_joy_vibration(0, rumble_weak_str, rumble_strong_str)
    
        
    
    
    
