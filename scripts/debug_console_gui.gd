extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
@onready var input: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/LineEdit
@onready var fps: Label = $FpsMarginContainer/FpsLabel

var is_open: bool = false
var history: Array = []
var history_idx: int
var previous_text: String

func _ready() -> void:
    panel.visible = false
    input.text_submitted.connect(on_submit)

func _input(event: InputEvent) -> void:
    
    if event.is_action_pressed(&"toggle_console"):
        toggle_console()
        
    if input.has_focus() and event.is_action_pressed(&"ui_text_indent"):
        input.text = DebugConsole.get_autocomplete(input.text.trim_suffix(" "))
        if input.text != "" and Callable(DebugConsole, input.text).get_argument_count() > 0:
            input.text += " "
        
        input.caret_column = input.text.length()
        
    if input.has_focus() and event.is_action_pressed(&"ui_cancel"):
        input.clear()
        toggle_console()
        
    if input.has_focus() and event.is_action_pressed(&"ui_up"):
        if history.size() == 0:
            return
        
        var input_col: int = input.caret_column
        if history_idx == null:
            history_idx = history.size()
        else:
            history_idx = max(history_idx - 1, 0)
        
        input.text = history[history_idx]
        input.caret_column = min(input_col, input.text.length())
    
    if input.has_focus() and event.is_action_pressed(&"ui_down"):
        if history.size() == 0:
            return
        
        if history_idx == history.size()-1:
            return
        
        var input_col: int = input.caret_column
        if history_idx == null:
            history_idx = history.size()
        else:
            history_idx = min(history_idx + 1, history.size()-1)
        
        input.text = history[history_idx]
        input.caret_column = min(input_col, input.text.length())

func toggle_console() -> void:
    is_open = !is_open
    panel.visible = is_open
    input.clear()

    if is_open:
        input.grab_focus()
        Syslog.info("Debug console opened.")
    else:
        Syslog.info("Debug console closed.")
        input.release_focus()

func on_submit(text: String) -> void:
    var args: Array = []
    
    if text == "":
        return
    
    text = text.trim_suffix(" ")
        
    history.append(text)
    history_idx = history.size()
    
    args = text.split(" ", false)
    
    input.clear()
    
    
    var nullp: Variant
    
    if args.size() > 1:
        var command: String = args.pop_front() # the command will always be the first entry
        nullp = DebugConsole.execute_command(command, args)
    else:
        nullp = DebugConsole.execute_command(text)
        
    if nullp != null:
        var ret_msg: String = nullp
        show_message(ret_msg)
        
func show_message(text: String) -> void:
    var msg: RichTextLabel = RichTextLabel.new()
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

    t.tween_interval(1)

    t.tween_property(msg, "modulate:a", 0.0, 1.0)\
        .set_trans(Tween.TRANS_CUBIC)\
        .set_ease(Tween.EASE_IN_OUT)

    t.tween_callback(msg.queue_free)
