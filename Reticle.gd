extends Node2D

@onready var master: Actor2D = GlobalRef.get_player()
@onready var ui_node: CanvasLayer = GlobalRef.get_ui()

var max_distance: float = 250
var min_visible_distance: float = 100.0

func _ready() -> void:
    $Sprite2D.frame = 1
    rotation = 0
    #reparent(master)

func lock_on() -> void:
    var sprite = $Sprite2D
    
    var t: Tween = create_tween()
    t.tween_property(self, ^"rotation", PI/2, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

    sprite.frame = 1
    
func lock_off() -> void:
    var sprite = $Sprite2D
    
    var t: Tween = create_tween()
    t.tween_property(self, ^"rotation", 0, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

    sprite.frame = 0
    
func _process(delta: float) -> void:
    if not master:
        return
    
    var master_screen_pos = master.get_global_transform_with_canvas() * Vector2.ZERO
    
    if InputDeviceManager.current_input_device == InputDeviceManager.InputDevices.KEYBOARD_MOUSE:
        global_position = get_global_mouse_position()
    else:
        global_position = global_position.move_toward(master_screen_pos + (master.controller.get_look_dir() * max_distance), 500/0.05*delta) 
    
    # Fade when cursor is too close to master (in screen space)
    var distance_to_master = global_position.distance_to(master_screen_pos)
    
    if distance_to_master <= min_visible_distance:
        # Lerp alpha from 1 (at min distance) to 0 (at 0 distance)
        modulate.a = lerp(0.0, 1.0, distance_to_master / min_visible_distance)
    else:
        modulate.a = 1.0
