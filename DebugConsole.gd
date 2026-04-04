extends Node

var history: Array = []

var callable_map: Dictionary = {
    "invalid": 'invalid',
    "invalid_args": 'invalid_args',
    "hello": "hello",
    "fullscreen": "fullscreen",
    "weapon_set": "weapon_set",
    "resolution": "resolution",
    "resolution_scale": "resolution_scale",
    "fps": "fps",
    "set_post_processing": "set_post_processing",
    "vsync": "vsync",
    "set_tps": "set_tps",
    "set_interpolation": "set_interpolation"
}

func set_tps(args: Array) -> String:
    var tps := int(args[0])

    if tps <= 0:
        return "TPS must be a positive integer"

    Engine.physics_ticks_per_second = tps
    return "Physics TPS set to %d" % tps

func set_interpolation(args: Array) -> String:
    var value := str(args[0]).to_lower()

    if value == "on":
        get_tree().physics_interpolation = true
        return "Physics interpolation enabled"

    if value == "off":
        get_tree().physics_interpolation = false
        return "Physics interpolation disabled"

    return "Invalid argument: use 'on' or 'off'"

func vsync(args: Array) -> String:
    var value := str(args[0]).to_lower()

    if value == "on":
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
        return "VSync turned on"

    if value == "off":
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
        return "VSync turned off"

    return "Invalid argument: use 'on' or 'off'"

func set_post_processing(args: Array) -> String:
    var on_off: String = args[0]
    var env: Environment = get_node("/root/Main/WorldEnvironment").environment
        
    if env == null:
        Syslog.error("No WorldEnvironment found!")
        return "No WorldEnvironment found!"
    
    match on_off:
        "on":
            env.glow_enabled = true
        "off":
            env.glow_enabled = false
        _:
            return "Wrong argument type. Expected either 'on' or 'off', got %s" % [on_off]

    return "post_processing turned %s" % [on_off]
    

func resolution(args: Array) -> String:
    var x: int = int(args[0])
    var y: int = int(args[1])

    var mode = DisplayServer.window_get_mode()
    if mode != DisplayServer.WINDOW_MODE_WINDOWED:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

    DisplayServer.window_set_size(Vector2i(x, y))

    return "Resolution set to %dx%d" % [x, y]
    
func resolution_scale(args: Array) -> String:
    var retval: String = ""
    var preset = args[0]
    
    match preset:
        "low":
            get_viewport().scaling_3d_scale = 0.5
            retval = "Resolution scale set to low preset."
        "medium":
            get_viewport().scaling_3d_scale = 0.75
            retval = "Resolution scale set to medium preset."
        "high":
            get_viewport().scaling_3d_scale = 1.0
            retval = "Resolution scale set to high preset."
        _:
            retval = "No such preset. Resolution scale unchanged."
            
    return retval

func weapon_set(args: Array) -> String:
    var handler: String = args[0]
    var property: String = args[1]
    var value: Variant = args[2]
    
    var main: Node = get_node("/root/Main")
    Syslog.debug("main_children: %s" % [main.get_children()])
    var player: Node = main.find_child("Player", true, false)
    var weapon: WeaponData
    
    var weapon_handler: WeaponHandler = player.find_child(handler, true, false)
    if weapon_handler == null:
        return "WeaponHandler not found: %s" % handler
    
    weapon = weapon_handler.weapon
    
    weapon.set_indexed(property, value)
    return "set %s.%s to %s" % [handler, property, value]
        

func hello() -> String:
    return "hello from cruxade with love!"

func invalid(args: Array) -> String:
    var text: String = args[0]
    var possible_text: String = ""
    var message_extension: String = ""
    
    if text == "invalid":
        return "This is the fallback command! You just started it manually. You deserve this: 🥚"
        
    possible_text = get_autocomplete(text)
    
    if possible_text != text: # if get_autocomplete returned text that means there was no match. If there was a match then we wouldn't be here, now would we?
        message_extension = " Did you mean: '%s'?" % [possible_text]
    
    return "[color='#FF0000']Error. No such command exists.[/color]%s" % [message_extension]

func invalid_args(args: Array) -> String:
    var expected: int = args[0]
    var given: int = args[1]
    
    return "[color='#FF0000']Wrong number of arguments for this command. Expected: [/color]%s[color='#FF0000'], got [/color]%s[color='#FF0000'].[/color]" % [expected, given]

func fullscreen() -> String:
    HotkeysManager.toggle_borderless() #TODO: This is all wrong lmao
    return "Toggled fullscreen mode."

@warning_ignore("untyped_declaration")
func execute_command(command: String, args: Array = []) -> Variant:     
    var nullp: Variant = callable_map.get(command, 'invalid')
    
    if nullp == null:
        return
        
    var callable: StringName = str(nullp)
    
    #sends command to invalid to offer guidance.
    if callable == 'invalid':
        args = [command]
    
    var retval: Variant
    
    if args.size() > 0 and Callable(self, callable).get_argument_count() > 0:
        Syslog.debug(args)        
        retval = call(callable, args)
    elif args.size() == 0 and Callable(self, callable).get_argument_count() == 0:
        retval = call(callable)
    else:
        retval = call('invalid_args', [Callable(self, callable).get_argument_count(), args.size()])
        
    return retval

func fps() -> String:
    var fps_visible: bool = DebugConsoleGui.fps.visible
    if not fps_visible:
        DebugConsoleGui.fps.visible = true
        return "FPS counter on."
    else:
        DebugConsoleGui.fps.visible = false
        return "FPS counter off."
    

func get_autocomplete(text: String) -> String:
    if text == "":
        return ""
    
    var autocompletes: Array = callable_map.keys()
    var matches: Array[String] #yes this rebuilds the array every time, even for the same input string. Caching isn't a big deal on this few entries.
    
    for i in range(0, autocompletes.size()):
         if autocompletes[i].match(text+'*'):
            matches.append(autocompletes[i])
    
    if matches.size() <= 0:
        return text
    
    var current_index: int #current selected match from matches. If none, will return first result.
    
    for i in range(0, matches.size()):
        if matches[i] == text:
            Syslog.debug("text: %s, string: %s, idx: %s" % [text, matches[i], i])
            current_index = (i + 1) % matches.size()
            Syslog.debug("idx_after: %s" % [current_index])
            break
    if current_index != null:
        return matches[current_index]
    else:
        return matches[0]
