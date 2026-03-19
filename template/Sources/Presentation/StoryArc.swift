import Foundation

// MARK: - Time Budget

struct TimeBudget {
    let act: Int
    let actTitle: String
    let startTime: TimeInterval   // seconds from presentation start
    let endTime: TimeInterval
}

// MARK: - Story Arc

enum StoryArc {

    static let timeBudgets: [TimeBudget] = {
        let acts: [(act: Int, title: String, start: TimeInterval, end: TimeInterval, count: Int)] = [
            (1, "Opening",      0 * 60,  2 * 60, 1),  // 2 min, 1 slide
            (2, "Canvas",       2 * 60,  5 * 60, 1),  // 3 min, 1 slide
            (3, "Animations",   5 * 60,  9 * 60, 2),  // 4 min, 2 slides
            (4, "Interactive",  9 * 60, 12 * 60, 2),  // 3 min, 2 slides
            (5, "Close",       12 * 60, 13 * 60, 1),  // 1 min, 1 slide
        ]
        var budgets: [TimeBudget] = []
        for act in acts {
            let duration = act.end - act.start
            let perSlide = duration / Double(act.count)
            for i in 0..<act.count {
                budgets.append(TimeBudget(
                    act: act.act,
                    actTitle: act.title,
                    startTime: act.start + perSlide * Double(i),
                    endTime: act.start + perSlide * Double(i + 1)
                ))
            }
        }
        return budgets
    }()

    static let slides: [SlideDescriptor] = [

        // ═══════════════════════════════════════════════════════════
        // ACT 1: OPENING (0:00–2:00)
        // ═══════════════════════════════════════════════════════════

        SlideDescriptor(
            id: "title",
            shortTitle: "Title",
            narrativeTitle: "SwiftUI: Beyond Static Slides",
            narrativeBullets: [
                "Every slide is a live SwiftUI animation",
                "The presentation framework IS the demo",
            ],
            stageContent: .scene(.titleCard),
            presenterNotes: "Let the sparkle icon animate in. Pause for effect — the audience sees the spring entry live."
        ),

        // ═══════════════════════════════════════════════════════════
        // ACT 2: CANVAS (2:00–5:00)
        // ═══════════════════════════════════════════════════════════

        SlideDescriptor(
            id: "canvas",
            shortTitle: "Canvas",
            narrativeTitle: "The Persistent Canvas",
            narrativeBullets: [
                "Elements live across slides — never recreated",
                "Step 1: horizontal row",
                "Step 2: vertical stack — same views, new positions",
                "Step 3: rotation + blur — still the same views!",
            ],
            stageContent: .scenes([.canvasIntro, .canvasMove, .canvasTransform]),
            presenterNotes: "Advance slowly through each step. Point out that the boxes are the SAME SwiftUI views — no destroy/recreate."
        ),

        // ═══════════════════════════════════════════════════════════
        // ACT 3: ANIMATIONS (5:00–9:00)
        // ═══════════════════════════════════════════════════════════

        SlideDescriptor(
            id: "morph",
            shortTitle: "Morph",
            narrativeTitle: "Morphing Layouts",
            narrativeBullets: [
                "6 colored nodes rearrange with staggered springs",
                "Grid → circle → tree — all animated",
                "matchedGeometryEffect-style fluidity, zero boilerplate",
            ],
            stageContent: .scenes([.layoutGrid, .layoutCircle, .layoutTree]),
            presenterNotes: "Each step morphs all 6 nodes. Emphasize zero boilerplate — just declare positions."
        ),
        SlideDescriptor(
            id: "orbiter",
            shortTitle: "Orbiter",
            narrativeTitle: "Continuous Animation",
            narrativeBullets: [
                "TimelineView + Canvas = 60fps particle orbiter",
                "8 hue-cycling particles with motion trails",
                "Runs alongside the persistent canvas",
            ],
            stageContent: .scene(.animationShowcase),
            presenterNotes: "This animates at 60fps without blocking navigation. Point out hue cycling and trail effects."
        ),

        // ═══════════════════════════════════════════════════════════
        // ACT 4: INTERACTIVE (9:00–12:00)
        // ═══════════════════════════════════════════════════════════

        SlideDescriptor(
            id: "focus",
            shortTitle: "Focus",
            narrativeTitle: "Focus & Blur",
            narrativeBullets: [
                "4 feature cards in a grid",
                "Each card zooms in one at a time while others blur",
                "Then all cards return — same persistent elements",
            ],
            stageContent: .scenes([.focusAll, .focusCanvas, .focusMorph, .focusAnimation, .focusInteractive, .focusAllReturn]),
            presenterNotes: "Advance through each card. The audience sees each feature highlighted, then the full grid returns."
        ),
        SlideDescriptor(
            id: "playground",
            shortTitle: "Particles",
            narrativeTitle: "Interactive Playground",
            narrativeBullets: [
                "150 particles following the mouse at 60fps",
                "Click to pin attractor points",
                "Full takeover — replaces the canvas entirely",
            ],
            stageContent: .takeover(.particlePlayground),
            presenterNotes: "Move the mouse around. Click a few times to create attractors. Let the audience play with it."
        ),

        // ═══════════════════════════════════════════════════════════
        // ACT 5: CLOSE (12:00–13:00)
        // ═══════════════════════════════════════════════════════════

        SlideDescriptor(
            id: "closing",
            shortTitle: "Close",
            narrativeTitle: "Thank You",
            narrativeBullets: [
                "The sparkle icon returns — persistent canvas brought it back",
                "Every animation you saw was SwiftUI, live",
            ],
            stageContent: .scene(.closingCard),
            presenterNotes: "The icon-hero reappears from the title card. Let it land — same element, full circle."
        ),
    ]
}
