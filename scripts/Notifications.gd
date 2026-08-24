extends Node
## Autoload. Bottom-right notification toast. Call Notifications.notify("text").

const FONT_PATH: String = "res://assets/fonts/Fleftex_M.ttf" # e.g. "res://assets/fonts/main_font.ttf", leave empty for default
const THEME_PATH: String = "res://resources/ui_theme/theme_01.tres" # e.g. "res://ui/notification_theme.tres", leave empty for none

const DISPLAY_DURATION: float = 2.5
const FADE_DURATION: float = 0.4

var container: VBoxContainer


func _ready() -> void:
    pass


func notify(text: String) -> void:
    if not container:
        var root: Node = GlobalRef.get_root()
    
        container = VBoxContainer.new()
        container.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
        container.grow_horizontal = Control.GROW_DIRECTION_BEGIN
        container.grow_vertical = Control.GROW_DIRECTION_BEGIN
        container.mouse_filter = Control.MOUSE_FILTER_IGNORE
        container.alignment = BoxContainer.ALIGNMENT_END
        
        if not THEME_PATH.is_empty():
            container.theme = load(THEME_PATH)
        
        root.add_child(container)
    
    var label: Label = Label.new()
    label.text = text
    
    if not FONT_PATH.is_empty():
        label.add_theme_font_override("font", load(FONT_PATH))
    
    container.add_child(label)
    
    var tween: Tween = get_tree().create_tween()
    tween.tween_interval(DISPLAY_DURATION)
    tween.tween_property(label, "modulate:a", 0.0, FADE_DURATION)
    tween.tween_callback(label.queue_free)
