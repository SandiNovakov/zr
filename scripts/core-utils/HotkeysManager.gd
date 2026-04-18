extends Node

var is_borderless: bool = false #TODO: FIX THIS SO IT ACTUALLY TAKES INTO ACCOUNT WHETHER GAME IS BORDERLESS OR NOT

func _input(event: InputEvent) -> void:
    if event.is_action_pressed(&"toggle_fullscreen"):
        toggle_borderless()

func toggle_borderless() -> void:
    is_borderless = !is_borderless

    if is_borderless:
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
