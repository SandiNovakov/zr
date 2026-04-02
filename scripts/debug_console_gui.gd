extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
@onready var input: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/LineEdit

var is_open := false

func _ready() -> void:
    panel.visible = false
    input.text_submitted.connect(on_submit)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed(&"toggle_console"):
        open_console()
        
    if input.has_focus() and event.is_action_pressed(&"ui_text_indent"):
        input.text = DebugConsole.get_autocomplete(input.text);
        input.caret_column = input.text.length()

func open_console() -> void:
    is_open = !is_open
    panel.visible = is_open
    input.clear()

    if is_open:
        input.grab_focus()
    else:
        input.release_focus()

func on_submit(text: String) -> void:
    input.clear()
    var nullp: Variant = DebugConsole.execute_command(text)
    
    if nullp != null:
        var ret_msg: String = nullp
        show_message(ret_msg)
        
func show_message(text: String) -> void:
    var msg := RichTextLabel.new()
    msg.bbcode_enabled = true
    msg.text = text
    msg.modulate.a = 0.0

    msg.fit_content = true
    msg.scroll_active = false

    container.add_child(msg)
    container.move_child(msg, container.get_child_count() - 2)

    var t: Tween = create_tween()

    t.tween_property(msg, "modulate:a", 1.0, 0.1)\
        .set_trans(Tween.TRANS_CUBIC)\
        .set_ease(Tween.EASE_IN_OUT)

    t.tween_interval(1.0)

    t.tween_property(msg, "modulate:a", 0.0, 1.5)\
        .set_trans(Tween.TRANS_CUBIC)\
        .set_ease(Tween.EASE_IN_OUT)

    t.tween_callback(msg.queue_free)
