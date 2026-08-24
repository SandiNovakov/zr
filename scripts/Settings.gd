extends Node
## Autoload. Persists settings + high score to disk and loads/applies them.
## Call `apply_settings()` after `save_settings()` (e.g. when the settings
## menu hits "Apply") to push the new values live via the resolution/window
## APIs -- those calls get filled in once you send them over.

const SAVE_PATH: String = "user://savedata.cfg"

const SECTION_SETTINGS: String = "settings"
const SECTION_SCORE: String = "score"

# -- settings --
var resolution: Vector2i = Vector2i(1920, 1080)
var fullscreen: bool = false
var background_detail: int = 2 # TODO: swap for an enum once detail levels are finalized
var effects_enabled: bool = true

# -- score --
var high_score: int = 0


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


## Pushes the currently held settings values live via the DebugCommands
## autoload's command functions.
func apply_settings() -> void:
    Syslog.info(
        "Applying settings: resolution=%s, fullscreen=%s, background_detail=%d, effects_enabled=%s."
        % [resolution, fullscreen, background_detail, effects_enabled]
    )
    
    if not fullscreen:
        var resolution_status: String = DebugCommands.resolution(resolution.x, resolution.y)
        Syslog.info(resolution_status)
        
    var graphics_status: String = DebugCommands.set_graphics(background_detail as DebugCommands.Levels)
    Syslog.info(graphics_status)
    
    var post_processing_status: String = DebugCommands.set_post_processing(effects_enabled)
    Syslog.info(post_processing_status)

    if fullscreen:
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        Syslog.info("Window mode set to fullscreen.")
    else:
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        Syslog.info("Window mode set to windowed.")


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
