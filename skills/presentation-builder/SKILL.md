---
name: presentation-builder
description: "Presentation Builder — use when the user wants to build, iterate on, or polish a native SwiftUI macOS presentation app that replaces slide decks with live animated interactive experiences."
argument-hint: "[phase or task description]"
---

# Presentation Builder

You are helping build and iterate on a native SwiftUI macOS presentation app. This app replaces slide decks with a live, animated, interactive experience using a proven architecture.

The user's message after `/presentation-builder` describes what phase they're in or what they want to do. If nothing is provided, assess the current state of the project and suggest what to work on next.

## Getting Started

If the user doesn't already have a presentation project, scaffold one from the bundled template:

1. Copy the `template/` directory from this plugin into the user's chosen project directory
2. Rename the package and app as needed
3. Run `swift build` to verify the template compiles
4. Begin with Phase 1 (Story Arc)

The template is a complete, buildable Swift Package (macOS 14+, Swift 5.9) with placeholder content ready to customize.

## Architecture Overview

The presentation app uses three separation layers:

1. **Story Arc** (`StoryArc.swift`) — The single authoring surface. An array of `SlideDescriptor` entries defines the entire presentation: titles, bullets, presenter notes, stage content, and time budgets organized by acts.

2. **Scene Registry** (`SceneRegistry.swift`) + **Element Catalog** (`ElementCatalog.swift`) — The visual layer. SceneRegistry maps SceneID → element positions using unit coordinates (0–1). ElementCatalog maps string keys → SwiftUI views. Together they define what appears on screen for each scene.

3. **Persistent Canvas** (`PersistentCanvasView.swift`) — The animation engine. A long-lived ZStack that never destroys. When the active scene changes, elements animate to new states: entering elements get spring + staggered delay, exiting elements get fast ease-out.

### Stage Content Types
- `.scene(SceneID)` — static/animated diagram on canvas
- `.scenes([SceneID])` — multiple diagrams, advance with steps within a slide
- `.takeover(TakeoverType)` — full interactive overlay replacing the canvas
- `.sceneThenTakeover(SceneID, TakeoverType)` — diagram first, then interactive

### Key Files
```
Sources/Presentation/
├── PresentationApp.swift          @main, two windows (main + presenter timer)
├── PresentationModels.swift       SlideDescriptor, StageContent, SceneID, ElementState
├── PresentationState.swift        @Observable state: activeSlide, sceneStep, elapsed
├── PresentationView.swift         Main layout + NavigationController (keyboard handling)
├── StoryArc.swift                 THE SLIDE ARRAY — edit this to change the presentation
├── WindowAccessor.swift           Hides presenter timer from screen capture
├── Stages/
│   ├── PersistentCanvasView.swift Animation engine (never destroys)
│   ├── SceneRegistry.swift        SceneID → element position snapshots
│   ├── ElementCatalog.swift       Element key → SwiftUI view mapping
│   └── DiagramContent.swift       Complex animated diagram views
└── Views/
    ├── StageView.swift            Canvas + takeover ZStack (right pane)
    ├── NarrativeSectionView.swift Bullet text + staggered animations (left pane)
    ├── SlideScrubber.swift        Dot navigation bar
    └── PresenterTimerView.swift   Speaker notes + pacing window
```

## Build Phases

### Phase 1: Story Arc
**Goal**: Define the narrative structure before touching visuals.

- Edit `StoryArc.swift` — add/remove/reorder `SlideDescriptor` entries
- Define acts with time budgets in `timeBudgets`
- For each slide: `id`, `shortTitle`, `narrativeTitle`, `narrativeBullets`, `presenterNotes`
- Assign `stageContent` with scene IDs (can be stubs — visuals come later)
- Add new `SceneID` cases to `PresentationModels.swift` as needed
- Add stub cases to `SceneRegistry.snapshot(for:)` (use `centered("diagram-name")`)

**Verification**: `swift build` should compile. Run the app — you should be able to navigate all slides with arrow keys, seeing placeholder diagrams.

### Phase 2: Stage Setting (Visuals + Animations)
**Goal**: Build the visual content for each scene.

For each scene, work through this loop:
1. **Add elements** to `ElementCatalog.allKeys` and `view(for:)` — either atomic (text, icons, images) or composite (diagram views)
2. **Position elements** in `SceneRegistry` using unit coordinates:
   - `(0.5, 0.5)` = center, `(0, 0)` = top-left
   - Set `opacity`, `scale`, `rotation`, `blur`, `zIndex` as needed
   - Elements not in a snapshot auto-hide (opacity 0, scale 0.5)
3. **Build diagrams** in `DiagramContent.swift`:
   - Static diagrams: computed properties returning `some View`
   - Animated diagrams: nested `View` structs that read `@Environment(\.activeScene)` and `@Environment(\.stageSize)` to trigger animations
   - For multi-phase animations, use `TimelineView` or `onChange(of: activeScene)`
4. **Test transitions** between adjacent scenes — elements should flow naturally

**Animation patterns**:
- Canvas transitions: automatic (spring + stagger in, ease-out exit)
- Diagram-internal animations: `withAnimation(.spring(duration:bounce:)) { phase += 1 }`
- Scroll/key-triggered: install `NSEvent.addLocalMonitorForEvents` in diagram views
- Frame-by-frame: `TimelineView(.animation)` for continuous animations

### Phase 3: Interactive Stages (Takeovers)
**Goal**: Build full-screen interactive overlays for demo slides.

1. Add new cases to `TakeoverType` in `PresentationModels.swift`
2. Build takeover views (full-screen, can contain any SwiftUI content)
3. Wire them up in `StageView.takeoverLayer(_:)`
4. If takeovers need configuration on slide entry, add setup logic in `PresentationView.onSlideEnter(_:)` with a 350ms delay (lets canvas fade-out complete)

### Phase 4: Content Refinement
**Goal**: Polish through repeated run-throughs.

Run the full presentation and adjust:
- Bullet text and presenter notes (in `StoryArc.slides`)
- Element positions (unit coordinate tweaking in `SceneRegistry`)
- Animation timing and stagger values (in `PersistentCanvasView`)
- Time budgets per act (in `StoryArc.timeBudgets`)
- Dot colors per slide type (in `SlideDescriptor.dotColor`)

### Phase 5: Polish
**Goal**: Handle edge cases and visual consistency.

- Keyboard navigation on interactive vs non-interactive slides
- Presenter timer pacing (adjust total budget in `PresenterTimerView`)
- Color palette consistency across diagrams
- Font size hierarchy (title: 42pt, subtitle: 20pt, body: 16pt, caption: 13pt)

## Conventions

- **Unit coordinates** for all element positioning (0...1 range)
- **Element keys** are semantic: `"icon-hero"`, `"label-title"`, `"diagram-architecture"`
- **SceneIDs** are flat enum cases, one per visual moment
- **Staggered entry**: entering elements animate at `index * 0.06s` delay
- **Fast exit**: exiting elements animate at `0.3s` with no delay
- **Takeover transition**: canvas fades out at `0.35s`, takeover fades in at `0.3s`
- **Navigation debounce**: 250ms between slide transitions
- **Presenter timer** is hidden from screen capture via `WindowAccessor`

## Working Style

- Always run `swift build` after structural changes to verify compilation
- Test navigation (arrow keys, space) after adding new slides
- When adding animated diagrams, start simple and layer complexity
- Keep the Story Arc as the single source of truth — don't hardcode content in views
- When the user says "run through" or "rehearsal", help them identify timing/content issues by reviewing the story arc and noting where pacing might be off
