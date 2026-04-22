extends Node2D

@onready var master: Actor2D = GlobalRef.get_player()
@onready var ui_node: CanvasLayer = GlobalRef.get_ui()

var max_distance: float = 250
var min_visible_distance: float = 100.0

var colorize_distance: float = 100.0

func _ready() -> void:
    $Sprite2D.frame = 0
    rotation = PI/2
    #reparent(master)
    GlobalRef.register_ref("reticle", self)
    master.locked_off.connect(lock_off)
    master.locked_on.connect(lock_on)

func lock_on() -> void:
    var sprite: AnimatedSprite2D = $Sprite2D
    
    var t: Tween = create_tween()
    var t2: Tween = create_tween()
    t.tween_property(self, ^"rotation", 0, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    t2.tween_property(self, ^"modulate", Pallete.get_color(Pallete.Colors.BULLET_BALLISTIC_2_TRAIL), 0.1)

    sprite.frame = 1
    
func lock_off() -> void:
    var sprite: AnimatedSprite2D = $Sprite2D
    
    var t: Tween = create_tween()
    var t2: Tween = create_tween()
    t.tween_property(self, ^"rotation", PI/2, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    t2.tween_property(self, ^"modulate", Color.WHITE, 0.1)

    sprite.frame = 0
    
func _process(delta: float) -> void:
    if not master:
        return
    
    var master_screen_pos: Vector2 = master.get_global_transform_with_canvas().origin
        
    if master.lock_on:
        var lock_on_pos: Vector2 = master.lock_on.get_global_transform_with_canvas().origin
        global_position = global_position.move_toward(lock_on_pos, 500/0.05*delta)
    else:
        if InputDeviceManager.current_input_device == InputDeviceManager.InputDevices.KEYBOARD_MOUSE:
            global_position = get_global_mouse_position()
        else:
            global_position = global_position.move_toward(master_screen_pos + (master.controller.get_look_dir() * max_distance), 500/0.05*delta) 
    
    colorize()
    
    # Fade when cursor is too close to master (in screen space)
    var distance_to_master: float = global_position.distance_to(master_screen_pos)
    
    if distance_to_master <= min_visible_distance:
        # Lerp alpha from 1 (at min distance) to 0 (at 0 distance)
        modulate.a = lerp(0.0, 1.0, distance_to_master / min_visible_distance)
    else:
        modulate.a = 1.0

func colorize() -> void:
    var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")

    var closest_distance: float = INF

    for enemy in enemies:
        if not enemy is Node2D:
            continue

        var enemy_screen_pos: Vector2 = enemy.get_global_transform_with_canvas().origin
        var dist: float = global_position.distance_to(enemy_screen_pos)

        if dist < closest_distance:
            closest_distance = dist

    if closest_distance == INF:
        modulate = Color.WHITE
        return

    var max_red_distance: float = 24.0      # deadzone: fully red inside this range
    var fade_distance: float = min_visible_distance

    if closest_distance <= max_red_distance:
        modulate = Color.RED

    elif closest_distance <= fade_distance:
        var t: float = inverse_lerp(
            fade_distance,
            max_red_distance,
            closest_distance
        )

        # t = 0 near fade edge, t = 1 near red zone
        modulate = Color(1.0, 1.0 - t, 1.0 - t, 1.0)

    else:
        modulate = Color.WHITE
    
