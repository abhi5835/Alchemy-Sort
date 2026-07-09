# ALCHEMY SORT OPTIMIZATION AND GAME FEEL

## Pre-Backend Architecture Review

**Settings Ownership Map**
- Music owner: AudioManager
- SFX owner: AudioManager
- Haptics owner: SettingsManager (No centralized haptics service found yet)
- Graphics owner: SettingsManager
- Frame rate owner: SettingsManager

**Initialization Order**
- AudioManager.init() -> SettingsManager.init()
- This ensures audio persistence is hydrated first. No races exist.

**Profile Persistence**
- ProfileScreen uses SettingsManager as a local repository boundary, keeping SharedPreferences out of the UI.

**Potions-Created Semantics**
- Gameplay event driven: YES.
- Evaluated on target tube completion, bounded by `_countedPotionTubeIndices` per level session.
- Undo farming is protected: Undo reverts tube colors, but `_countedPotionTubeIndices` retains the completion flag for that tube index, preventing lifetime stat farming.

**Highest-Combo Status**
- Implemented: YES (in `GameWorld` via `LevelSessionStats`)
- Shown: NO
- Persisted: NO (Handled purely in-memory per session)

**Level-Map Listener Architecture**
- Previous listener pattern: ~340 individual ValueListenableBuilders inside the map.
- Current listener count: 1.
- Rebuild scope: Rebuilds the single Stack containing all 340 level nodes and the cached path painter.

**Eager Level-Node Status**
- All level nodes eagerly created using List.generate: YES.

**Path Cache Invalidation**
- Cache owner: `DashedPathPainter` (static members)
- Dependencies: `size`, `levelCount`, `nodeGap`.
- Invalidation safe: YES. Recomputes if dimensions change.

**RepaintBoundary Locations**
- Count: 1
- Location: Wrapping the `DashedPathPainter` (static dashed background layer).

**Performance Overlay Behavior**
- SHOW_PERFORMANCE_OVERLAY flag is required for profile mode viewing. Hidden by default in Release. Uses a 1-second rolling window for FPS metrics to limit string allocations.

**Graphics-Quality Budgets**
- High: 8 to 14 particles
- Balanced: 4 to 7 particles
- Battery Saver: 0 particles, but preserves the subtle tube glow, text, haptic, and SFX.

**Frame-Rate Preference Behavior**
- Preference stored; no platform display mode request currently implemented.

**Backend Extension Point**
- Current boundary: `SettingsManager` (concrete local singleton).
- Recommended remote extension point: Extract an abstract `ProfileRepository`, implement with a local cache layer and remote API coordinate layer.

## Alchemy World Map UI Redesign

**Product Decisions**
- Redesigned into a magical casual-game identity (soft lavender, magical blue, warm cream, gold highlights).
- World grouped into 20-level sections (Mystic Garden, Crystal Caves, Moonlight Lab, Dragon Alchemy, Enchanted Swamp, Celestial Tower).
- The map uses an energy path instead of dashed dots.
- Eager 340-node limitation preserved for now. Estimated visible nodes: ~7-10.

**MainScreen Architecture**
- `MainScreen` is a StatefulWidget serving as a tab shell.
- Tab retention strategy: `LevelMapScreen` is preserved via `PageStorageKey`. Profile, Potions, and Daily screens are re-built on demand, with `embedded: true` to adjust their AppBars.
- Gameplay opens outside the tab shell (standard `Navigator.push`).

**Map State**
- Scroll position preserved: YES (via `PageStorageKey` and instance caching).
- Auto-scroll execution: Occurs post-frame on map initialization to target ~65% of viewport height.

**World Architecture**
- Theme model: `AlchemyWorldTheme`
- Background: `AlchemyWorldBackground`
- Rendering: `_WorldBackgroundPainter` handles a unified scrolling background with procedural elements matching the current height range.
- Section transitions: Overlapping boundaries and unified gradients.

**Level Nodes**
- Completed: Magic circle with stars.
- Current: Gold ring with subtle pulse.
- Locked: Desaturated with lock icon.
- Special: Milestone levels every 10 levels (square shapes).
- Current animation controllers: 1 (only the `isCurrent` node creates an animation).
- All nodes eagerly created: YES.

**HUD**
- Avatar source: `SettingsManager().profileNotifier`
- Avatar reactive: YES.
- Stats: Gold stars capsule showing `GameManager().score`.

**Daily**
- Floating shortcut: YES (`AlchemyEventButton`).
- Bottom tab: YES (DAILY).
- Same feature: YES.

**Bottom Navigation**
- Tabs: MAP, DAILY, POTIONS, PROFILE.
- Existing Potion Book reused: YES.
- Existing Profile reused: YES.

**Performance**
- Single unlock listener: YES.
- Path cache: YES (`EnergyPathPainter` caches its path).
- Per-node listeners: 0
- Per-node animation controllers: Only 1 (for the active node).
- Graphics Quality: Background elements scale with quality settings (though mostly static in this phase).
- PROFILE MEASUREMENT: NOT MEASURED (Manual device test required).
