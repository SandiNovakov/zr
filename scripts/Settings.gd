extends Node
## Autoload. Persists settings + high score to disk and loads/applies them.
## Call `apply_settings()` after `save_settings()` (e.g. when the settings
## menu hits "Apply") to push the new values live via the resolution/window
## APIs.

enum GraphicsPreset { LOW, MEDIUM, HIGH }

const SAVE_PATH: String = "user://savedata.cfg"

const SECTION_SETTINGS: String = "settings"
const SECTION_SCORE: String = "score"

# -- settings --
var resolution: Vector2i = Vector2i(1920, 1080)
var fullscreen: bool = false
var background_detail: int = 2 # GraphicsPreset value, stored as int for ConfigFile
var effects_enabled: bool = true

# -- score --
var high_score: int = 0

## Score from the run that just ended. Transient (not persisted) - set by
## Main right before switching to the score display scene, since
## Util.change_scene() has no other way to hand data to the new scene.
var last_score: int = 0


func _ready() -> void:
    Syslog.info("Initializing save data.")
    load_data()


func load_data() -> void:
    var cfg: ConfigFile = ConfigFile.new()
    var err: Error = cfg.load(SAVE_PATH)
    
    if err != OK:
        Syslog.warning("No save data found at %s, using defaults." % [SAVE_PATH])
        return
    
    Syslog.info("Save data loaded successfully from %s." % [SAVE_PATH])
    
    resolution = cfg.get_value(SECTION_SETTINGS, "resolution", resolution)
    fullscreen = cfg.get_value(SECTION_SETTINGS, "fullscreen", fullscreen)
    background_detail = cfg.get_value(SECTION_SETTINGS, "background_detail", background_detail)
    effects_enabled = cfg.get_value(SECTION_SETTINGS, "effects_enabled", effects_enabled)
    
    high_score = cfg.get_value(SECTION_SCORE, "high_score", high_score)
    
    Syslog.info(
        "Loaded settings: resolution=%s, fullscreen=%s, background_detail=%d, effects_enabled=%s."
        % [resolution, fullscreen, background_detail, effects_enabled]
    )
    Syslog.info("Loaded high score: %d." % [high_score])


func save_settings() -> void:
    Syslog.info("Saving settings.")
    
    var cfg: ConfigFile = ConfigFile.new()
    cfg.load(SAVE_PATH) # keep whatever's already saved under other sections
    
    cfg.set_value(SECTION_SETTINGS, "resolution", resolution)
    cfg.set_value(SECTION_SETTINGS, "fullscreen", fullscreen)
    cfg.set_value(SECTION_SETTINGS, "background_detail", background_detail)
    cfg.set_value(SECTION_SETTINGS, "effects_enabled", effects_enabled)
    
    var err: Error = cfg.save(SAVE_PATH)
    if err != OK:
        Syslog.error("Failed to save settings to %s (error %d)." % [SAVE_PATH, err])
        return
    
    Syslog.info(
        "Settings saved: resolution=%s, fullscreen=%s, background_detail=%d, effects_enabled=%s."
        % [resolution, fullscreen, background_detail, effects_enabled]
    )


## Pushes the currently held settings values live via the window/display APIs.
func apply_settings() -> void:
    Syslog.info(
        "Applying settings: resolution=%s, fullscreen=%s, background_detail=%d, effects_enabled=%s."
        % [resolution, fullscreen, background_detail, effects_enabled]
    )

    if not fullscreen:
        _apply_resolution(resolution.x, resolution.y)

    _apply_graphics_preset(background_detail as GraphicsPreset)
    _apply_post_processing(effects_enabled)

    if fullscreen:
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        Syslog.info("Window mode set to fullscreen.")
    else:
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        Syslog.info("Window mode set to windowed.")


func _apply_resolution(p_width: int, p_height: int) -> void:
    if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

    DisplayServer.window_set_size(Vector2i(p_width, p_height))
    Syslog.info("Resolution set to %dx%d." % [p_width, p_height])


func _apply_graphics_preset(p_preset: GraphicsPreset) -> void:
    var background: SubViewport = GlobalRef.get_background()

    if not background:
        Syslog.info("Graphics preset not applied, no background available.")
        return

    match p_preset:
        GraphicsPreset.LOW:
            background.size = Vector2(960, 540)
        GraphicsPreset.MEDIUM:
            background.size = Vector2(1920, 1080)
        GraphicsPreset.HIGH:
            background.size = Vector2(3840, 2160)

    Syslog.info("Graphics set to %s preset." % [p_preset])


func _apply_post_processing(p_enabled: bool) -> void:
    var world_env: WorldEnvironment = GlobalRef.get_world_env()

    if not world_env:
        Syslog.error("No WorldEnvironment found!")
        return

    world_env.environment.glow_enabled = p_enabled
    Syslog.info("Post-processing %s." % [Util.enabled_disabled(p_enabled)])


func save_high_score(score: int) -> void:
    if score <= high_score:
        Syslog.info(
            "High score not updated: %d is not greater than current high score of %d."
            % [score, high_score]
        )
        return
    
    Syslog.info("New high score: %d (previous: %d)." % [score, high_score])
    
    high_score = score
    
    var cfg: ConfigFile = ConfigFile.new()
    cfg.load(SAVE_PATH)
    cfg.set_value(SECTION_SCORE, "high_score", high_score)
    
    var err: Error = cfg.save(SAVE_PATH)
    if err != OK:
        Syslog.error("Failed to save high score to %s (error %d)." % [SAVE_PATH, err])
        return
    
    Syslog.info("High score saved successfully: %d." % [high_score])


func get_high_score() -> int:
    Syslog.info("Retrieved high score: %d." % [high_score])
    return high_score
