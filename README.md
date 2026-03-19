# Presentation Builder

A Claude Code plugin for building native SwiftUI macOS presentation apps that replace slide decks with live, animated, interactive experiences.

https://github.com/user-attachments/assets/694e30c8-2de3-4ed5-b2cc-7f4808a9d010

## What it does

The `/presentation-builder` skill guides Claude through a proven architecture for building presentation apps with:

- **Story Arc** — a single data-driven slide array as the source of truth
- **Scene Registry + Element Catalog** — unit-coordinate positioning and SwiftUI view mapping
- **Persistent Canvas** — a long-lived animation engine with spring entries and fast exits
- **Takeover stages** — full-screen interactive overlays for live demos

## Install

**Use as a plugin (local):**
```bash
git clone https://github.com/zacspa/PresentationBuilder.git
claude --plugin-dir ./PresentationBuilder
```

**Or copy the skill into your project:**
```bash
mkdir -p .claude/skills/presentation-builder
curl -o .claude/skills/presentation-builder/SKILL.md \
  https://raw.githubusercontent.com/zacspa/PresentationBuilder/main/skills/presentation-builder/SKILL.md
```

**Or install globally for all projects:**
```bash
mkdir -p ~/.claude/skills/presentation-builder
curl -o ~/.claude/skills/presentation-builder/SKILL.md \
  https://raw.githubusercontent.com/zacspa/PresentationBuilder/main/skills/presentation-builder/SKILL.md
```

## Template

The plugin includes a complete, buildable SwiftUI macOS project template in `template/`. When you run `/presentation-builder` in a directory without an existing project, Claude will scaffold from this template.

You can also copy it manually:

```bash
cp -r /path/to/PresentationBuilder/template/ ~/Development/MyPresentation/
cd ~/Development/MyPresentation
swift build && swift run
```

The template includes:
- 7 placeholder slides across 3 acts (Opening, Core Content, Close)
- Title card, closing card, and diagram placeholders
- A live demo takeover stub
- Presenter timer window (hidden from screen capture, Cmd+T)
- Keyboard navigation (arrows, space, escape)
- Dot scrubber with color-coded slide types

### Template Structure
```
template/
├── Package.swift                              Swift 5.9, macOS 14+
└── Sources/Presentation/
    ├── PresentationApp.swift                  @main, two windows
    ├── PresentationModels.swift               Core types
    ├── PresentationState.swift                @Observable shared state
    ├── PresentationView.swift                 Main layout + keyboard nav
    ├── StoryArc.swift                         THE SLIDE ARRAY (edit this)
    ├── WindowAccessor.swift                   Screen capture hiding
    ├── Stages/
    │   ├── PersistentCanvasView.swift         Animation engine
    │   ├── SceneRegistry.swift                Scene → element positions
    │   ├── ElementCatalog.swift               Element key → SwiftUI view
    │   └── DiagramContent.swift               Diagram view patterns
    └── Views/
        ├── StageView.swift                    Canvas + takeover ZStack
        ├── NarrativeSectionView.swift         Bullet text pane
        ├── SlideScrubber.swift                Dot navigation bar
        └── PresenterTimerView.swift           Speaker notes + pacing
```

## Usage

```
/presentation-builder              # Assess project state and suggest next steps
/presentation-builder phase 1      # Work on story arc / narrative structure
/presentation-builder add scene    # Add a new visual scene
/presentation-builder polish       # Refine timing, animations, and content
```

## Architecture

The plugin teaches Claude a 5-phase build process:

| Phase | Goal |
|-------|------|
| **1. Story Arc** | Define narrative structure in `StoryArc.swift` |
| **2. Stage Setting** | Build visuals and animations per scene |
| **3. Interactive Stages** | Add full-screen takeover overlays |
| **4. Content Refinement** | Polish through rehearsal run-throughs |
| **5. Polish** | Edge cases, consistency, and final tuning |

## Key Conventions

- Unit coordinates (0–1) for all element positioning
- Semantic element keys (`"icon-hero"`, `"diagram-architecture"`)
- Staggered spring entry (0.06s per element), fast ease-out exit (0.3s)
- 250ms navigation debounce
- Presenter timer hidden from screen capture

## License

MIT
