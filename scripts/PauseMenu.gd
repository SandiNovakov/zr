extends CanvasLayer
class_name PauseMenu
## Simple pause menu. Darkens the screen and offers resume / exit-to-title.
## Expected scene tree (attach this script to the CanvasLayer root):
##
## PauseMenu (CanvasLayer)
## ├── Background (ColorRect)  -- full rect, semi-transparent black
## └── CenterContainer
##     └── VBoxContainer
##         ├── ResumeButton (Button)
##         └── ExitButton (Button)

const TITLE_SCREEN_PATH: String = "res://scenes/title_screen.tscn"

@onready var background: ColorRect = $Background
@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton
@onready var exit_button: Button = $CenterContainer/VBoxContainer/ExitButton


func _ready() -> void:
    # needs to keep running (and receive input) while the tree is paused
    process_mode = Node.PROCESS_MODE_ALWAYS
    background.color = Color(0, 0, 0, 0.5)
    
    resume_button.pressed.connect(_on_resume_pressed)
    exit_button.pressed.connect(_on_exit_pressed)
    
    visible = false


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        toggle_pause()
        get_viewport().set_input_as_handled()


func toggle_pause() -> void:
    if get_tree().paused:
        resume()
    else:
        pause()


func pause() -> void:
    visible = true
    get_tree().paused = true
    resume_button.grab_focus()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    RumbleController.stop_all()


func resume() -> void:
    visible = false
    get_tree().paused = false
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    


func _on_resume_pressed() -> void:
    resume()


func _on_exit_pressed() -> void:
    get_tree().paused = false
    Util.change_scene(TITLE_SCREEN_PATH)
