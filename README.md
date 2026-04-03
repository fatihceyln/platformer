<video src="https://github.com/user-attachments/assets/be021216-c56b-493e-b3a6-ee3a3b64ef9b" controls playsinline></video>

# Notes
In Godot, everything is made up of Nodes.

---

Scenes allow us to group multiple nodes together and use them as a reusable structure. For example, when we create a Player scene, it can contain nodes such as `CharacterBody2D`, `AnimatedSprite2D`, and `CollisionShape2D`. We can then place this scene inside other scenes — this is called scene nesting.

---

The scene highlighted in blue in the FileSystem panel is the Main Scene — the one that runs when the Play button is pressed. To change it, right-click any scene and select **Set as Main Scene**.

---

`AnimatedSprite2D` is used to create animations by combining multiple frames. In 2D, visuals are referred to as Sprites.

---

When multiple sprites are packed into a single PNG file, that file is called a Sprite Sheet. This way, all animation frames live in one file instead of hundreds of separate ones. The same approach applies to static visuals like environment tiles — all environment sprites used throughout the game can be packed into a single PNG.

---

Press `F` to focus on any node in the editor.

---

The **Default Texture Filter** setting under Project Settings → Rendering → Textures defaults to **Linear**. If you are developing a pixel art game, change this to **Nearest**; otherwise, Linear applies anti-aliasing and you won't get hard edges.

---

When using `AnimatedSprite2D` or `Sprite2D`, the sprite must be correctly positioned relative to its origin point (0, 0). Otherwise, alignment issues will appear in the scene. For example, if the sprite is shifted up on the Y axis, the character will appear to float above the ground; if shifted on the X axis, it will appear offset to the left or right. Correct positioning: X = 0, vertically centered on the Y axis.

---

`CharacterBody2D` is a physics node, and all physics nodes must be given a `CollisionShape2D`. Without it, the engine has no way of knowing which objects this node can collide with. The same applies to `StaticBody2D` — without a `CollisionShape2D`, it cannot collide with other physics nodes.

---

A `TileSet` must be assigned to the `TileMapLayer` node. The **Tile Size** field in the Inspector defaults to 16×16 pixels and must match the size of the assets being used. If the assets are 32×32, Tile Size must be updated to 32×32 accordingly. After assigning the TileSet and painting tiles, placing the Player on top will cause it to fall through — because the painted tiles don't have a physics layer yet. To add physics: select the `TileMapLayer` node → Inspector → **Physics Layers** → **Add Element**.

---

In the TileSet editor, select the Physics Layer from the **Paint Properties** section, then paint each tile that should have physical collision individually. Decorative tiles do not need physics applied.

---

> **Note:** The `TileMap` node has been deprecated as of Godot 4.3. The official documentation now recommends using `TileMapLayer` nodes instead. The concepts above (physics layers, tile painting, tile size) still apply — only the node name has changed.

---

`AnimatableBody2D` is the node to use for moving platforms that interact physically with other objects. It can be animated and, while moving, interacts with other physics nodes in its path.

---

`Sprite2D` can be used to design static UI elements. A texture must be assigned via the Inspector. If using a sprite sheet, enabling the **Region** property allows you to use only a specific portion of the sheet.

---

The **One Way Collision** property on `CollisionShape2D` makes the collision valid in only one direction. For example, when enabled on a platform, the player can jump up through it from below, but cannot pass through it from above.

---

The render order of nodes is managed with **Z-Index**. The value can be increased or decreased under Inspector → CanvasItem → Ordering. Two settings to keep in mind: **Z as Relative** should be enabled, and **Y Sorting Enabled** should be disabled. The default Z-Index value is 0 for all nodes.

---

`Area2D` is used to define a region for detecting overlaps without creating physical collisions. When a physics body enters the area, the overlap is detected — `Area2D` itself does not participate in collisions.

---

Unlike `_ready()`, which runs only once, `_process()` runs every frame. This makes it suitable for things that change over time, such as enemy movement — the position is shifted by a small amount each frame to produce motion.

---

In-game actions (jump, move, shoot, etc.) and their key bindings are managed through Project Settings → **Input Map**. Multiple keys can be assigned to a single action; for example, both `A` and the left arrow key can be mapped to move left simultaneously.

---

Godot has three different nodes for playing audio:

- `AudioStreamPlayer` — for non-positional audio. Use this for background music and UI sounds that should play regardless of the position of any character or object in the world.
- `AudioStreamPlayer2D` — for positional audio in 2D space. Sound attenuates with distance from the listener (usually the camera). Use this for sound effects that originate from a specific location in the world.
- `AudioStreamPlayer3D` — same concept as `AudioStreamPlayer2D`, but for 3D games.

In short: use `AudioStreamPlayer` for background music, and `AudioStreamPlayer2D` for world-positioned sound effects.

---

Audio volume management is handled through the **Audio Bus** structure, accessible from the **Audio** tab at the bottom of the editor. Under the **Master** bus, separate buses such as Music and SFX can be created, each with its own independent volume level. This approach is preferred over changing Volume DB on individual audio files — it allows features like an in-game music volume slider to be implemented easily. The bus an audio file plays through is set via Inspector → **Bus Properties** when the file is selected.

---

AutoLoads are global scenes and scripts that remain loaded in memory for the entire lifetime of the game. Common use cases include global game managers, service locator patterns, and background music that should not be interrupted by scene transitions. For example, a scene containing an `AudioStreamPlayer` node can be added as an AutoLoad so that music continues uninterrupted when switching scenes. To add an AutoLoad: Project Settings → **AutoLoad** tab.

---
`AnimationPlayer` is used to add animations via property tracks and keyframes. It can also be used not for visual animation but as a **timeline** — for example, hiding a coin, playing a sound, and then removing the node. Method tracks let you invoke any function (such as `queue_free()`) at a specific point in the timeline. For this kind of sequenced flow, using a `Timer` is generally not the recommended approach.

---

Signals are Godot's built-in notification system. You emit a signal on one node and connect it to a handler on another. In spirit, this is similar to Swift's `NotificationCenter`, but signals are typed and scoped to a node rather than being global by default.

---

Every physics body and area has two distinct layer settings:

- **Collision layer** — which layer(s) this body or area *is on*.
- **Collision mask** — which layer(s) it *detects and interacts with*.

A body only reacts to another body if their layer and mask overlap.

---

`get_tree().reload_current_scene()` restarts the current scene from the beginning. A common use case is a game over → reload loop.

---

`delta` is the time in seconds elapsed since the previous frame. Always multiply movement and other time-dependent values by `delta` inside `_process()` or `_physics_process()` to keep behavior frame-rate independent.

---

For pixel-art games, prefer font sizes that are multiples of **8**. Arbitrary font sizes often render blurry or uneven because they don't align cleanly with the pixel grid.

---

`Node` is the simplest node type — it has no 2D transform (no position, rotation, or scale). `Node2D` extends it by adding position, rotation, and scale in 2D space.

---

If you mark a node as **unique** in the editor, you can reference it from anywhere within the same scene using the `%NodeName` shorthand instead of a full node path. Example: `@onready var game_manager = %GameManager`.

---

`$NodeName` is shorthand for `get_node("NodeName")`. Example: `$Player/Weapon` is equivalent to `get_node("Player/Weapon")`.

---

`@export var some_node: Node` exposes a variable as a slot in the Inspector, allowing you to assign a node directly from the editor. This is conceptually similar to `@IBOutlet` / `@IBInspectable` in UIKit.

---

`class_name MyClass` gives a script a globally accessible class name that can be used anywhere in the project without needing to `preload` or `load` the script manually.

---

`tree_exited` is a signal emitted when a node has fully left the scene tree. After calling `queue_free()`, connecting to `tree_exited` (or its equivalent `on_tree_exited()`) is a reliable way to know the node is truly gone.

---

GDScript warning levels are configured per-project under **Project → Project Settings → Debug → GDScript** and stored in `project.godot` under `[debug]`. Severity values: `0` = ignore, `1` = warn, `2` = error.

Enabling stricter settings catches typing mistakes and API misuse before runtime — similar in spirit to Swift's strict type system, though GDScript remains dynamic.

| Setting | Level | What it does |
|---|---|---|
| `untyped_declaration` | Error | Requires explicit type annotations on variables and parameters. |
| `inferred_declaration` | Error | Flags declarations that rely solely on type inference where explicit annotations are expected. |
| `unsafe_property_access` | Error | Flags property reads/writes on values the type system cannot verify as safe. |
| `unsafe_method_access` | Error | Flags method calls on insufficiently typed values. |
| `unsafe_cast` | Error | Flags casts that may fail at runtime. |
| `unsafe_call_argument` | Error | Flags arguments passed to calls where the type doesn't match safely. |
| `return_value_discarded` | Warn | Flags ignored return values (e.g. error codes, node references). |
| `missing_await` | Warn | Flags async calls made without `await`. |

Note: settings under **Editor → Editor Settings** are user-local and not stored in the repository.

---

**Architecture — call down, signal up.** Prefer calling methods directly on child nodes from a parent. For communicating upward or between siblings, emit signals and let a common parent coordinate. This keeps coupling low and the scene tree predictable.

---

GDScript supports **inner classes** defined inside a script using the `class` keyword.

---

GDScript does **not** support multiple inheritance. Favor composition over deep inheritance hierarchies.

---

**Shaders in Godot 4** are written in a GLSL-like language and saved as `.gdshader` files. The first line must declare `shader_type`, which determines the available built-ins and `render_mode` options.

Available `shader_type` values:

- `spatial` — 3D meshes; outputs PBR values like `ALBEDO` and `NORMAL`.
- `canvas_item` — All 2D `CanvasItem` and `Control` drawing; final output goes through `COLOR`.
- `particles` — Per-particle simulation (motion and state), not pixel shading.
- `sky` — Used with `Sky` resources for environment backdrops.
- `fog` — Used with `FogVolume` for volumetric fog color and density.
- `texture_blit` — Used when writing into drawable textures with custom per-pixel logic.

A **ShaderMaterial** references the `.gdshader` file and holds the `uniform` values, which can be adjusted from GDScript or animated via `AnimationPlayer`.

---

**`canvas_item` fragment() built-ins** (relevant for 2D overlay shaders):

- `UV` — Texture coordinates in 0–1 range from `vertex()`. On a fullscreen `ColorRect`, `(0.5, 0.5)` is the center, which is useful for radial masks.
- `COLOR` — As input: vertex color multiplied by the texture sample (if a texture exists). As output: assigning `COLOR` sets the final RGBA of the pixel.
- `SCREEN_PIXEL_SIZE` — The size of one screen pixel (inverse of viewport resolution). The ratio `y / x` corrects UV distances to keep circular masks round on non-square viewports.
- `TEXTURE` — The node's default texture sampler. A plain `ColorRect` has no texture, so sampling `TEXTURE` is unnecessary — `COLOR` is the correct base.
- `SCREEN_UV` — Screen-space UV (0–1 across the viewport). Use with a `uniform sampler2D` marked `hint_screen_texture` to read pixels already rendered behind the current item. This replaces the old `SCREEN_TEXTURE` built-in from Godot 3.

---

**GPUParticles2D** is the node for GPU-driven 2D particle effects, suited to dense bursts like confetti, sparks, or dust. Key properties:

- **`ParticleProcessMaterial`** — Assigned to `process_material`; controls direction, spread, velocity, gravity, damping, scale curves, color, and hue variation.
- **`amount`** and **`lifetime`** — Balance these to control density and duration.
- **One-shot burst** — Set `one_shot = true` with high `explosiveness`, then set `emitting = true` and call `restart()` each time you want a new burst. Connect the `finished` signal to `queue_free()` to clean up the instance automatically after the effect ends.

**CPUParticles2D** is the CPU-based alternative. Preferable for very small particle counts, easier to step through during development, or when GPU particles are not suitable for the target platform.