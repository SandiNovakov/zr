Style guide for godot project!

# 1. Naming Rules
## 1.1. GDScript
### 1.1.1. Naming conventions in GDScript
Variables should in almost all cases be named in a clear manner. If a longer name is required to disambiguate the purpose of a variable, then it is preferable to use the longer name. Never abbreviate `@export` variables.

Examples of good and bad variable names:
```gdscript
# Bad variable names:
var num_3 # unclear what the "3" means. One would need to know the context.
@export var spd # even if the purpose is clear, this will look ugly in-editor.

var bps_ps # base player speed per second, obviously.

# Good variable names:
var speed
var swap_number # indicates a throwaway number that only serves an algorithmic purpose. Better than number_2.
var move_dir # common abbreviations are acceptable in scoped variables that won't appear more often than a few lines, or as arguments in a function call.
```

Special cases:
```gdscript
var retval 
# retval is an old convention for storing the state of a variable. It is acceptable to use this a catch-all for any return value in a function.

var nullref
var null_ref
# both are acceptable in cases when a function may return something other than the variable's type and it is preferable to handle the error than to crash. Use case:

func return_string_or_null() -> Variant:
    return string_or_null_typed_value
    
func _ready() -> void:
    var typed_value: String
    
    var null_ref: Variant = return_string_or_null()
    if null_ref == null:
        Syslog.warning("function returned null!")
        typed_value = ""
    else:
        typed_value = str(null_ref)
        

for i: int in range(range):
    pass
# "i" as an index in ranges is a common programming idiom. It is the preferred name to use for traversing a range.
```
### 1.1.2. Cases in GDScript
The following are our casing conventions for gdscript:
```gdscript
# variables and functions use snake_case:
var fire_rate: int
func useful_function() -> void:
    pass

# constants and enum values use MACRO_CASE:
const LIFETIME: float
enum {
    FIRST,
    SECOND,
    THIRD
}

# classes and enum names use PascalCase:
class ActorController
enum NamedEnum{
    VALUES,
    ETC,
}
```
### 1.1.3. Function vs. procedures
There is a discussion on where procedures and functions differ. Here we will be using their intended meaning from the PL/SQL world:
- A function is a block of code which returns a value for a given input.
- A procedure is a block of code which is executed when called. Its actions may be changed depending on its input.

In short: functions typically fetch data, procedures act upon data.

This should be reflected in code. Here are some examples to illustrate:
```gdscript
# functions:
func get_speed() -> int:
    return speed

static func get_difference(num1: int, num2: int) -> int:
    return num1 - num2

# procedures:
func move(move_dir: Vector2, delta: float, p_speed: int = speed) -> void:
    pass
    
func turn(look_dir: Vector2, p_turn_speed: int, delta: float) -> void:
    pass
    
func enable_shooting() -> void:
    pass
```
functions should in almost all cases never have side-effects! There are some exemptions such as the `InputBuffer.is_action_buffered()` function which sets the action's `consumed` tag to `true` if it returns true, but those should have a clear use case and reason!

### 1.1.4. Best practices

#### 1.1.4.1. Prefer "for" loops over "for each" loops for complex array manipulation.
```gdscript
# in some cases, using:
for i: int in range(0, list.size() - 1, 1):
    list[i] = something
# is better than iterating through the array by element:
for element: Variant in list:
    pass
# Although the for each loop is no less performant than the for loop, in most cases knowing the index of the element can help with complex array manipulation, such as deleting items by index.
```
Let's say we wanted to delete the records just before and after the one that matched out criteria. Using a for-each loop this would be difficult. We'd need to manually get the index of our current item and then still delete by index. Using a for loop, we already know the index. Removing those elements is as simple as removing from the array at i+1 and i-1.

#### 1.1.4.2. Provide dedicated getters for properties which rely on external logic.
A good example is ActorController. Originally a controller that only existed for player input checking, ActorController is supposed to be a generic class for all kinds of Actor2D's, including enemies. So while the Actor2D and its states check the ActorController for input, they do so through function calls—getters, as opposed to raw variable access.

The upside to this is that if the implementation of `get_move_dir()` ever changes to be different for different types of Actor2D's, the Actor2D's will be none the wiser. They'll just keep calling `get_move_dir()` as if nothing happened.

Another example is CoreConfig. CoreConfig switched to getter functions after multiple changes in the logic and naming behind internal variables made it difficult to keep track of the references to the individual variables. Now everything just calls a getter function and relies on CoreConfig to figure out what it wants. If we ever want to change what variable a setting points to, it's as simple as altering the function call.

## 1.2. Files
These are the conventions for file naming cases:
```
# all folder names should be in kebab-case:
assets/
useful-scripts/

# when a class has its own folder, the name is converted to kebak-case:
actor-controller/
actor2d/

# .gd files use snake_case:
/boost.gd
/boost_charge.gd

# .gd files for classes use PascalCase:
Actor2D.gd
ActorController.gd
```

