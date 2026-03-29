extends Node
class_name ModulateFlasher

@export var enabled: bool
@export var color_1: Pallete.Colors
@export var color_2: Pallete.Colors
@export var flash_speed: float
@export var transition: Tween.TransitionType
@export var easing: Tween.EaseType
@export var self_modulate: bool

var tween: Tween
@onready var parent: Node = get_parent()

func _process(delta: float) -> void:
    if tween == null and enabled:
        _start_tween()
    
    if tween != null and not enabled:
        _end_tween()   

func _start_tween() -> void:
    var property: String = "modulate"
    
    if self_modulate:
        property = "self_modulate"
    
    if not Util.has_property(parent, property):
        Syslog.error("%s attempted to set property: %s of parent %s but parent has no such property. Disabling behavior and returning..." % [self.name, property, parent.name])
        enabled = false
        return
    
    tween = create_tween()
    tween.tween_property(parent, property, Pallete.get_color(color_1), flash_speed).set_trans(transition).set_ease(easing)
    tween.set_loops()
    tween.tween_property(parent, property, Pallete.get_color(color_2), flash_speed).set_trans(transition).set_ease(easing)

func _end_tween() -> void:
    if tween:
        tween.kill()
        tween = null
