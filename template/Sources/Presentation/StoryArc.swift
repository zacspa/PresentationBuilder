import Foundation

// MARK: - Time Budget

struct TimeBudget {
    let act: Int
    let actTitle: String
    let startTime: TimeInterval   // seconds from presentation start
    let endTime: TimeInterval
}

// MARK: - Story Arc
//
// The single authoring surface for the presentation.
// Add, remove, or reorder slides by editing this array.
// Everything else (canvas, narrative, scrubber) derives from this.

enum StoryArc {

    // Per-slide time budgets, linearly interpolated from act boundaries.
    // Edit the acts array to define your presentation's pacing.
    static let timeBudgets: [TimeBudget] = {
        let acts: [(act: Int, title: String, start: TimeInterval, end: TimeInterval, count: Int)] = [
            (1, "Opening",      0 * 60,  5 * 60, 2),  // 5 min, 2 slides
            (2, "Core Content", 5 * 60, 20 * 60, 3),  // 15 min, 3 slides
            (3, "Close",       20 * 60, 25 * 60, 2),  // 5 min, 2 slides
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
        // ACT 1: OPENING (0:00–5:00)
        // ═══════════════════════════════════════════════════════════

        SlideDescriptor(
            id: "title",
            shortTitle: "Title",
            narrativeTitle: "Your Presentation Title",
            narrativeBullets: [
                "Subtitle or tagline",
                "Your Name",
            ],
            stageContent: .scene(.titleCard),
            presenterNotes: "Breathe. Make eye contact. Let the title sit for a beat."
        ),
        SlideDescriptor(
            id: "overview",
            shortTitle: "Overview",
            narrativeTitle: "The Problem",
            narrativeBullets: [
                "What problem existed?",
                "Why did it matter?",
                "What was the cost of inaction?",
            ],
            stageContent: .scene(.overview),
            presenterNotes: "Set the scene. Make the audience feel the pain."
        ),

        // ═══════════════════════════════════════════════════════════
        // ACT 2: CORE CONTENT (5:00–20:00)
        // ═══════════════════════════════════════════════════════════

        SlideDescriptor(
            id: "architecture",
            shortTitle: "Architecture",
            narrativeTitle: "How It Works",
            narrativeBullets: [
                "High-level architecture",
                "Key components and their roles",
                "Data flow through the system",
            ],
            stageContent: .scene(.architecture),
            presenterNotes: "Walk through the diagram. Point to each component as you explain it."
        ),
        SlideDescriptor(
            id: "key-decision",
            shortTitle: "Decisions",
            narrativeTitle: "Key Technical Decisions",
            narrativeBullets: [
                "What trade-offs did you face?",
                "What did you choose and why?",
                "What was the result?",
            ],
            stageContent: .scene(.keyDecision)
        ),
        SlideDescriptor(
            id: "demo",
            shortTitle: "Demo",
            narrativeTitle: "Live Demo",
            narrativeBullets: [
                "What you're about to see",
                "What to watch for",
            ],
            stageContent: .takeover(.interactiveDemo),
            presenterNotes: "Keep it short. Show, don't tell."
        ),

        // ═══════════════════════════════════════════════════════════
        // ACT 3: CLOSE (20:00–25:00)
        // ═══════════════════════════════════════════════════════════

        SlideDescriptor(
            id: "impact",
            shortTitle: "Impact",
            narrativeTitle: "Impact",
            narrativeBullets: [
                "Metric 1: before vs after",
                "Metric 2: before vs after",
                "What it unlocked for the team/org",
            ],
            stageContent: .scene(.impact)
        ),
        SlideDescriptor(
            id: "closing",
            shortTitle: "Q&A",
            narrativeTitle: "Questions?",
            narrativeBullets: [
                "Your Presentation Title",
                "Your Name",
            ],
            stageContent: .scene(.closingCard),
            presenterNotes: "Pause. Let the audience come to you."
        ),
    ]
}
