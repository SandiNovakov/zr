# Codebase Report: Complexity & Simplification Opportunities

Written 2026-08-26. Scope: `scripts/`, root-level `.gd` singletons, and how they're wired
through `project.godot` and the `.tscn` scenes. Goal: flag places where the systems have
grown bigger than the game currently needs, so you can decide what to trim before
submission.

## Overall shape

It's a Godot 4.6 top-down twin-stick shooter. Core gameplay loop is small and reasonably
clean: `Actor2D` (player/enemy) drives a `StateMachine` of `ActorState`s (Idle, Dash,
Boost, BoostCharge, BoostRecovery, ChargedShotRecoil), each `WeaponHandler` runs its own
mini state machine (Idle/Charging/Charged) over the same `State`/`StateMachine` base
classes, and `Bullet` is a simple `CharacterBody2D` with `move_and_collide`. That reuse of
one `State`/`StateMachine` pair for both actors and weapons is a good call — it's the
strongest part of the architecture.

Around that small core, though, there's a disproportionate amount of infrastructure:
logging, a debug console with typed argument parsing, a fake-event generator, an HTML log
viewer with embedded CSS/JS, rumble/vibration management, a cheat-code detector, a second
scene-transition system, and a collision-preset library. Individually each is well
written; together they're a lot of surface area for a solo college project, and several of
them are either unused or duplicated by something simpler that's actually load-bearing.

## Dead code (safe to delete outright)

- **`scripts/weapon-handler/DamageData.gd`** — empty file, zero bytes, nothing references
  it. `Bullet.gd` carries `damage: int` directly instead.
- **`HitBox2D.gd`** and **`CollisionLibrary.gd`** (project root) — not attached to any
  `.tscn`, not instantiated anywhere. `CollisionLibrary` is a layer/mask preset system
  (`Layer` enum, `Preset` class, bit-packing helpers) built specifically for `HitBox2D`,
  which itself is never used. Meanwhile the code that *does* set collision layers
  (`WeaponHandler._spawn_bullet`) does it by hand with raw `set_collision_layer_value(5,
  true)` calls — so the library that was built to avoid magic numbers is dead, and the
  magic numbers it was meant to replace are still the ones actually running. Delete both
  files, or finish wiring `CollisionLibrary` into `Bullet`/`Actor2D` and delete the manual
  layer-setting instead — don't keep both.
- **`scripts/transition.gd` (`Transition` class)** — a full shader-based circular wipe
  transition (custom `canvas_item` shader written inline as a string, tween in/out,
  overlay management) that is never called. Every actual scene change in the game
  (`PauseMenu`, `title_screen.tscn`, `settings.tscn`) goes through the much simpler
  `Util.change_scene()`, which just frees children and instances the new scene with no
  transition at all. Either delete `transition.gd`, or replace `Util.change_scene` with
  it — right now you're maintaining two competing implementations of the same function
  and only one is reachable.
- **`scripts/core-utils/RingBuffer.gd`** — despite the name, this is a Konami-code-style
  key-sequence buffer (`_unhandled_input` pushes typed keys into `keypresses`, exposes
  `check_sequence()`). It defines five cheat-code sequences (`cheat_code`,
  `castle_array`, `buddha_array`, `caffeine_array`, `admin_array`, `ghost_array`) but
  `check_sequence()` is never called from anywhere in the project — none of the cheats
  actually do anything. It's also autoloaded (`project.godot` line 29), so it's running
  `_unhandled_input`/`_process` every frame for no effect. Either hook the cheats up to
  something (even a `Syslog.info` per code) or delete the autoload.
- **`scripts/core-utils/SyslogDebug.gd`** — autoloaded generator that, when
  `CoreConfig.fake_debug_messages` is on, fires a random log line from a 33-case `match`
  block every 0.02–0.5s (fake FPS drops, fake network timeouts, fake save corruption,
  etc.) purely to have something to look at in the log viewer. `fake_debug_messages`
  defaults to `false` in `CoreConfig`, so in practice this whole file does nothing at
  runtime — it exists to generate demo data for the HTML log viewer below. Worth cutting
  unless you specifically want it for a demo/screenshot.

## Over-built for what it's used for

- **The logging stack** (`Syslog` → `LogUtility` → `HtmlUtil`, configured via
  `CoreConfig`) supports four simultaneous destinations — plain print, BBCode-colored
  print, a `.txt` file, and a full **HTML file with an embedded `<style>` block,
  `<script>` block, a live JS text filter, a collapsible sidebar, and an ASCII cat easter
  egg** (`HtmlUtil.write_html_header`, ~215 lines just for the header). `log_to_html_file`
  defaults to `true`, so every play session currently writes one of these out to
  `user://`. This is the single biggest "went overboard" item in the project — a
  browser-based log viewer with search/filter UI is the kind of thing a small team builds
  for a live-service game's ops workflow, not a tool you need to grade a student project.
  Cutting it down to `print_rich` (which you already have, with per-level colors) plus
  optionally a plain `.txt` file removes `HtmlUtil.gd` entirely and simplifies `Syslog`
  and `LogUtility` to two destinations instead of four.
- **`DebugCommands` / `DebugConsole` / `debug_console_gui`** — a full typed command
  shell: an `ArgTypes` enum (`INT`, `FLOAT`, `STRING`, `BOOL`, `LEVEL`, `BOOL_LEVEL`),
  per-argument min/max validation, default values, a `CommandArg`/`Command` class pair,
  autocomplete with tab-cycling and history, and a generated usage-string builder
  (`build_arg_syntax`). That's a lot of generality for **11 commands total**, several of
  which (`hello`, `fullscreen` — whose own body says `#TODO: This is all wrong lmao`) are
  placeholders. A `match` statement on a plain string command with manual `split(" ")`
  parsing would cover the same 11 commands in a fraction of the code, and you'd lose
  nothing you're actually using (no command currently needs range validation or a
  `LEVEL`/`BOOL_LEVEL` custom type distinction beyond `set_vibration` and
  `set_graphics`/`set_resolution_scale`).
- **`Pallete`** — the pattern (one `@export var` + one `enum` entry + one dictionary
  entry, times ~15 colors) means adding a single new color requires editing three places
  in `pallete.gd` in lockstep, and `get_color()` returns `Variant` because of the `NULL`
  enum case. This is used by real, active code (`Trail2D`, `ModulateFlasher`, dash/boost
  states, `Reticle`) so it shouldn't be deleted, but the indirection is more than it needs
  to be. A `Dictionary[StringName, Color]` exported directly (or a `Resource` with one
  `@export var colors: Dictionary`) would give you the same "central place to tweak
  colors" property with one declaration per color instead of three, and callers would
  pass `&"boost_start"` instead of `Pallete.Colors.BOOST_START` — same ergonomics, a third
  of the boilerplate.
- **`RumbleController`** — supports two independent APIs for the same effect: `add()`
  (fire-and-forget, times out on its own) and `start()`/`end()` (caller holds an ID and
  ends it manually) layered over a list of concurrent `Rumble` objects that get
  max-strength-combined every physics tick. In practice every call site uses one-shot
  durations *or* holds the handle for the state's lifetime — never both patterns
  overlapping. It works and isn't broken, just worth knowing it's more general (multiple
  simultaneous rumble sources blending) than the game currently exercises (usually one
  state's rumble at a time).

## Structural inconsistency (not a bug, but worth fixing before it spreads)

- Most scripts live under `scripts/<category>/`, but five classes —
  `GlobalRef.gd`, `CollisionLibrary.gd`, `HitBox2D.gd`, `LockOnController.gd`,
  `Reticle.gd` — sit at the project root instead. `GlobalRef` and `LockOnController` are
  both actively used (`GlobalRef` especially — it's the service locator every autoload
  and state relies on), so this isn't dead code, just misfiled. Worth moving into
  `scripts/core-utils/` and `scripts/actor2d/` respectively for consistency, and deleting
  `CollisionLibrary.gd`/`HitBox2D.gd` per above rather than relocating them.
- `GlobalRef.gd` has `@warning_ignore_start("untyped_declaration") # Reason:
  vibe-coded` on its registration functions — an honest marker that this section wasn't
  written to the same typing standard as the rest of the (otherwise consistently
  fully-typed) codebase. Since `GlobalRef` is core plumbing every autoload touches, this
  is a good candidate to clean up to match the rest of the project's style (explicit
  types on `register_ref`/`clear_ref`/`_get_ref`) even though it currently works.
- There's a stray editor temp file, `scenes/settings.tscn6977661643.tmp`, checked into
  the tree next to `scenes/settings.tscn`. Harmless but worth deleting/gitignoring so a
  reviewer doesn't wonder if it's meaningful.

## What's *not* over-built

Worth saying explicitly, since the ask was specifically about trimming: the
`State`/`StateMachine` reuse between `Actor2D` and `WeaponHandler`, the `Actor2D` /
`ActorController` split (with `player_controller`, `dummy_controller` for
enemies/scripted actors, and `null_controller` as a safe no-op default), `WeaponData` as
a `Resource` for data-driven weapons, and `InputBuffer`/`InputDeviceManager` for
buffered input + controller/KBM switching are all appropriately sized for what they do
and are actively exercised by the game. None of that needs simplifying.

## Suggested priority if you want to cut

1. Delete: `DamageData.gd`, `HitBox2D.gd`, `CollisionLibrary.gd`, `transition.gd`,
   `SyslogDebug.gd`, the `RingBuffer` autoload (or wire its cheats up to something real),
   the stray `.tmp` scene file. This alone removes ~500 lines and two autoloads with zero
   behavior change.
2. Strip `HtmlUtil.gd` and the `HTML_FILE` log destination out of
   `Syslog`/`LogUtility`/`CoreConfig`, keep `print_rich` + optional plain-text file.
3. Flatten `DebugCommands`/`DebugConsole`'s typed-argument system down to a simple
   string-`match` command table if you don't plan to add many more console commands
   before submission.
4. Optional polish: collapse `Pallete`'s export/enum/dictionary triplication to a single
   exported `Dictionary`, move the five root-level scripts into `scripts/`, type up
   `GlobalRef`'s "vibe-coded" section.

Let me know which of these you want done and I'll implement them.
