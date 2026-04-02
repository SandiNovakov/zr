extends Node

var callable_map: Dictionary = {
    "invalid": 'invalid',
    "hello": "hello",
}
func hello() -> String:
    return "hello from cruxade with love!"

func invalid() -> String:
    return "[color='#FF0000']Error. No such command exists.[/color]"

func execute_command(command: String) -> Variant:     
    var nullp: Variant = callable_map.get(command, 'invalid')
    
    if nullp == null:
        return
        
    var callable: StringName = str(nullp)
    
    var retval: Variant = call(callable)
    return retval

func get_autocomplete(text: String) -> String:
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
