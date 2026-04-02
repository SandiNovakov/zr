extends Node

var callable_map: Dictionary = {
    "invalid": 'invalid',
    "hello": "hello",
    "fullscreen": "fullscreen"
}

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

func fullscreen() -> String:
    HotkeysManager.toggle_borderless() #TODO: This is all wrong lmao
    return "Toggled fullscreen mode."

@warning_ignore("untyped_declaration")
func execute_command(command: String, ...args) -> Variant:     
    var nullp: Variant = callable_map.get(command, 'invalid')
    
    if nullp == null:
        return
        
    var callable: StringName = str(nullp)
    
    #sends command to invalid to offer guidance.
    if callable == 'invalid':
        args = [command]
    
    var retval: Variant
    
    if args.size() > 0:
        retval = call(callable, args)
    else:
        retval = call(callable)
    
    return retval

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
