<video src="https://github.com/user-attachments/assets/fe97f4c3-23a6-48ed-85c9-d87536205c38" controls playsinline></video>

# Notes

## Sprites & world building

- **Sprite sheet** — When you pack all sprites into a single PNG file, that image is called a sprite sheet.
- **TileMap** — You build a 2D world with a TileMap. You can add multiple layers to one TileMap so you can separate midground, background, and similar depth.
- **AnimatableBody2D** — Use this for moving physics bodies, for example moving platforms.

## Animation & interaction

- **AnimationPlayer** — You add animations here, often as property tracks with keyframes.
- **Area2D** — Lets you detect overlaps and collisions involving areas (e.g. triggers, pickups).
- **Signals** — Emit and connect signals for notifications across the game, similar in spirit to Swift’s `NotificationCenter`.

## Physics layers

- **Collision layer** — Which layer(s) this body or area *is* on.
- **Collision mask** — Which layer(s) it *interacts* with.

## Scene flow & timing

- `get_tree().reload_current_scene()` — Restarts the current scene from the beginning. Useful for a game over → reload loop.
- `delta` — Time in seconds since the previous frame (use in `_process` / `_physics_process` for frame-rate–independent motion).

## UI & pixel art

- **Font size** — For pixel-art games, prefer font sizes that are multiples of **8** so text stays crisp; arbitrary sizes often look blurry or uneven.

## Shaders

Notes tied to `shaders/circle_transition_shader.gdshader`, the game-over dim overlay, and canvas-item shaders in general.

- **GDShader** — Text-based shader (`.gdshader`). The first line must set **`shader_type`**, which determines available **built-ins** and **`render_mode`** options.
- **ShaderMaterial** — References the shader and holds **uniform** values (adjust from GDScript or animate with **AnimationPlayer**).
- **`fragment()`** — Runs per pixel; typical uses include color math, texture sampling, and masks. Here it adjusts **alpha** for a circular iris wipe over the dim **ColorRect**.

**`shader_type` (Godot 4):**

- **`spatial`** — 3D meshes and materials; outputs such as `ALBEDO`, `NORMAL`, and other PBR-related values.
- **`canvas_item`** — All **CanvasItem** / **Control** drawing; final output goes through **`COLOR`** (and **`light()`** when 2D lighting applies).
- **`particles`** — Particle **simulation** stage (per-particle motion and state), not ordinary pixel shading of the scene.
- **`sky`** — Used with **Sky** resources (environment backdrop).
- **`fog`** — Used with **FogVolume** (volumetric fog color and density).
- **`texture_blit`** — Used when blitting into **drawable** textures with optional custom per-pixel logic.

**Canvas item `fragment()` built-ins (relevant here):**

- **`UV`** — Texture coordinates from **`vertex()`**, typically **0–1**; on a fullscreen **ColorRect**, **(0.5, 0.5)** is the center (useful for radial masks).
- **`COLOR`** — **Input:** vertex color (with modulate / self_modulate) multiplied by the default **`TEXTURE`** sample when a texture exists. **Output:** assigning **`COLOR`** sets the final RGBA. The transition shader keeps only **alpha** multiplied by the circular mask.
- **`SCREEN_PIXEL_SIZE`** — Size of one pixel; matches the **inverse of viewport resolution**. The ratio **`y / x`** corrects UV distances so a circular mask stays round on non-square windows.
- **`TEXTURE`** — Default sampler; **`texture(TEXTURE, UV)`** reads the node’s texture. A plain **ColorRect** has no texture, so the shader need not sample **`TEXTURE`**; **`COLOR`** remains the correct base.
- **`SCREEN_UV`** — Screen-space UV (0–1 across the viewport). Use with a **`uniform sampler2D`** marked **`hint_screen_texture`** to read what was already drawn behind the item (Godot 4 replaces the old **`SCREEN_TEXTURE`** built-in).

**Functions in the circle transition shader:**

- **`length`** — Distance from the UV center after recentering and aspect scaling.
- **`max`** — Avoids unsafe division and supplies the maximum distance to corners for the wipe radius.
- **`step`** — Hard step (0 or 1); **`1.0 - step(edge, distance)`** yields an **inside / outside** mask for the circle.

**This project** — `materials/circle_transition_shader_material.tres` on **`GameManager/Overlay/Dim`** (fullscreen black **ColorRect**); the **`progress`** uniform controls the wipe.

## Particles

**Confetti** — `scenes/confetti_burst.tscn`, instantiated from **`GameManager._spawn_confetti_at_player`** when all coins are collected.

- **`GPUParticles2D`** — GPU-driven 2D particles; suited to dense effects (e.g. confetti, sparks, dust).
- **`ParticleProcessMaterial`** — Set on **`process_material`**; controls direction, spread, velocity, gravity, damping, angular velocity, scale curves, color, hue variation, and 2D-oriented flags (e.g. disable Z).
- **Texture** — Per-particle **`Texture2D`** on the node. Balance **`amount`** and **`lifetime`** for density and duration.
- **One-shot burst** — **`one_shot`** with high **explosiveness** produces a short burst. After spawning, set **`emitting = true`** and call **`restart()`** so each instance runs a new burst (see **`GameManager._spawn_confetti_at_player`**).
- **`finished` signal** — After a one-shot cycle, connect **`finished`** to **`queue_free`** to remove the instance when the effect ends.
- **`CPUParticles2D`** — CPU simulation; preferable for very small counts, easier stepping through behavior during development, or when GPU particles are unsuitable on a target platform.

## Nodes & scenes

- `Node` — The simplest node type; it has no 2D transform (no position, scale, or size in the 2D sense). (`Node2D` adds position, rotation, and scale.)
- **Unique nodes** — If you mark a node as unique in the editor, you can reference it from the same scene without a long path using `%NodeName`, for example: `@onready var game_manager = %GameManager`.
- **Autoloads (globals)** — **Project → Project Settings → Globals** — Register scripts or scenes that stay alive for the whole game, independent of the current scene. Somewhat like a lightweight service locator or DI-style registry.

## Pickups & lifecycle

- **Coin pickup pattern** — An `AnimationPlayer` sequence can be used not for “showy” animation but as a **timeline**: hide the coin, play a sound, then remove the node. You can also **invoke methods** from the animation timeline (method tracks); that is how you typically call `queue_free()` at the right moment. For that kind of flow, relying on a `Timer` is often **not** the recommended approach.
- `tree_exited` **/** `on_tree_exited()` — Runs when the node leaves the tree; after `queue_free()`, this is one way to know the node is really gone from the scene.

## Scripting & paths

- `$` **shorthand** — Same as `get_node()`. Example: `$Player/Weapon` is equivalent to `get_node("Player/Weapon")`.
- `@export var some_node: Node` — Exposes a slot in the inspector so you can assign a node from the editor, similar in idea to `@IBInspectable` in UIKit.
- `class_name` — Gives a script a global class name you can use throughout the project.

## GDScript warnings (project settings)

These options live in **`project.godot`** under **`[debug]`** (editor path: **Project → Project Settings → Debug → GDScript**). They control how the analyzer treats potential mistakes. Severity is stored as a number: **`0`** = ignore, **`1`** = warn, **`2`** = error.

### Why enable stricter settings?

The goal is **safer, more maintainable scripts**: catch typing and API misuse **before** runtime, keep types **explicit** where it matters, and avoid “silent” bugs from discarded return values or forgotten `await`. It is similar in spirit to stricter checks in languages like Swift—GDScript is still dynamic, but the editor can enforce a **disciplined** style across the whole project.

### This project’s values

| Setting | Level | What it does |
|--------|--------|----------------|
| `untyped_declaration` | **Error** | Disallows untyped `var` / parameters where the project expects explicit types (or consistent typing rules). |
| `inferred_declaration` | **Error** | Flags declarations that rely only on inference when the project wants explicit annotations for clarity and tooling. |
| `unsafe_property_access` | **Error** | Warns when you read/write a property on a value the type system cannot prove safe (e.g. `Variant`-like paths). |
| `unsafe_method_access` | **Error** | Same idea for method calls on insufficiently known types. |
| `unsafe_cast` | **Error** | Flags casts that may fail at runtime if the value is not the assumed type. |
| `unsafe_call_argument` | **Error** | Flags passing values into calls where the argument type does not match safely. |
| `return_value_discarded` | **Warn** | If a function returns a meaningful value (e.g. error codes, nodes), ignoring it is flagged—helps avoid ignored errors. |
| `missing_await` | **Warn** | If you call something that should be `await`ed (async flow) without `await`, you get a reminder. |

**Summary:** The first six are set to **error** so the codebase stays **typed and safe** at analysis time; the last two stay **warnings** so you get nudges without necessarily blocking every build on style-heavy cases.

**Note:** Preferences under **Editor → Editor Settings → Text Editor → GDScript** (theme, completion, etc.) are **user-local** and are **not** stored in this repo—only **Project Settings** entries in `project.godot` are shared with the project.

## Architecture

- **Call down, signal up** — Prefer calling methods on children from parents, and notifying parents (or the rest of the tree) with **signals** going upward. For **sibling** communication, still use signals and let a **parent** coordinate.
- **Inner classes** — GDScript supports inner classes.
- **Inheritance** — GDScript does **not** support multiple inheritance; favor **composition** over deep inheritance hierarchies.
