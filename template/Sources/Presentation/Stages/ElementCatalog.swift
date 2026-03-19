import SwiftUI

/// Maps string keys to SwiftUI views.
enum ElementCatalog {
    static let allKeys: [String] = [
        // Atomic — title/closing
        "icon-hero",
        "label-title",
        "label-subtitle",
        "label-presenter",
        "label-closing-title",
        "label-closing-subtitle",
        // Canvas demo (slide 2)
        "canvas-box-a",
        "canvas-box-b",
        "canvas-box-c",
        "canvas-label",
        // Morph nodes (slide 3)
        "morph-0",
        "morph-1",
        "morph-2",
        "morph-3",
        "morph-4",
        "morph-5",
        // Orbiter (slide 4)
        "orbiter",
        // Feature cards (slide 5)
        "card-canvas",
        "card-morph",
        "card-animation",
        "card-interactive",
    ]

    @ViewBuilder
    static func view(for key: String) -> some View {
        switch key {
        // ── Atomic: title / closing ──────────────────────────
        case "icon-hero":
            Image(systemName: "sparkles")
                .font(.system(size: 64, weight: .thin))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

        case "label-title":
            Text("SwiftUI: Beyond Static Slides")
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(.primary)

        case "label-subtitle":
            Text("Every slide is a live animation")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.secondary)

        case "label-presenter":
            VStack(spacing: 8) {
                Divider().frame(width: 120)
                Text("Built with PresentationBuilder")
                    .font(.system(size: 14))
                    .foregroundStyle(.tertiary)
            }

        case "label-closing-title":
            Text("Thank You")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.primary)

        case "label-closing-subtitle":
            Text("Every animation was SwiftUI, live.")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.secondary)

        // ── Canvas boxes (slide 2) ───────────────────────────
        case "canvas-box-a":
            DiagramContent.canvasBox(color: .blue, label: "Layout", icon: "rectangle.3.group")

        case "canvas-box-b":
            DiagramContent.canvasBox(color: .purple, label: "Animate", icon: "wand.and.stars")

        case "canvas-box-c":
            DiagramContent.canvasBox(color: .orange, label: "Persist", icon: "arrow.triangle.2.circlepath")

        case "canvas-label":
            DiagramContent.CanvasExplainerLabel()

        // ── Morph nodes (slide 3) ────────────────────────────
        case "morph-0": DiagramContent.morphNode(index: 0)
        case "morph-1": DiagramContent.morphNode(index: 1)
        case "morph-2": DiagramContent.morphNode(index: 2)
        case "morph-3": DiagramContent.morphNode(index: 3)
        case "morph-4": DiagramContent.morphNode(index: 4)
        case "morph-5": DiagramContent.morphNode(index: 5)

        // ── Orbiter (slide 4) ────────────────────────────────
        case "orbiter":
            DiagramContent.OrbiterView()

        // ── Feature cards (slide 5) ──────────────────────────
        case "card-canvas":
            DiagramContent.featureCard(
                title: "Persistent Canvas",
                icon: "square.stack.3d.up",
                color: .blue,
                description: "Elements survive across slides — no recreation, pure animation."
            )
        case "card-morph":
            DiagramContent.featureCard(
                title: "Layout Morphing",
                icon: "arrow.triangle.branch",
                color: .purple,
                description: "Rearrange elements between any layout with staggered springs."
            )
        case "card-animation":
            DiagramContent.featureCard(
                title: "60fps Animation",
                icon: "sparkles",
                color: .orange,
                description: "TimelineView + Canvas for buttery smooth continuous animation."
            )
        case "card-interactive":
            DiagramContent.featureCard(
                title: "Takeover Demos",
                icon: "hand.tap",
                color: .green,
                description: "Full-screen interactive overlays for live coding and particle sims."
            )

        default:
            EmptyView()
        }
    }
}
