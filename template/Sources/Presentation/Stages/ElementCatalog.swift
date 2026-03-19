import SwiftUI

/// Maps string keys to SwiftUI views.
///
/// Two kinds of elements:
/// - **Atomic**: simple text, icons, images (e.g. "label-title")
/// - **Composite**: complex diagram views (e.g. "diagram-architecture")
///
/// To add a new element:
/// 1. Add its key to `allKeys`
/// 2. Add its view in the `view(for:)` switch
/// 3. Position it in SceneRegistry for the scenes where it appears
enum ElementCatalog {
    static let allKeys: [String] = [
        // Atomic — title/closing
        "icon-hero",
        "label-title",
        "label-subtitle",
        "label-presenter",
        "label-closing-title",
        "label-questions",
        // Composite — diagrams (add yours here)
        "diagram-overview",
        "diagram-architecture",
        "diagram-keyDecision",
        "diagram-impact",
    ]

    @ViewBuilder
    static func view(for key: String) -> some View {
        switch key {
        // ── Atomic: title / closing ──────────────────────────
        case "icon-hero":
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 64, weight: .thin))
                .foregroundStyle(.blue.opacity(0.6))

        case "label-title":
            Text("Your Presentation Title")
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(.primary)

        case "label-subtitle":
            Text("A Subtitle or Tagline")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.secondary)

        case "label-presenter":
            VStack(spacing: 8) {
                Divider().frame(width: 120)
                Text("Your Name")
                    .font(.system(size: 14))
                    .foregroundStyle(.tertiary)
            }

        case "label-closing-title":
            Text("Thank you!")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.primary)

        case "label-questions":
            Text("Questions?")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.secondary)

        // ── Composite: diagrams ──────────────────────────────
        // Replace these placeholders with your actual diagram views.
        case "diagram-overview":
            DiagramContent.placeholder(title: "Overview Diagram", subtitle: "Replace with your problem visualization")

        case "diagram-architecture":
            DiagramContent.placeholder(title: "Architecture Diagram", subtitle: "Replace with your system diagram")

        case "diagram-keyDecision":
            DiagramContent.placeholder(title: "Key Decision", subtitle: "Replace with your decision visualization")

        case "diagram-impact":
            DiagramContent.placeholder(title: "Impact Metrics", subtitle: "Replace with your metrics visualization")

        default:
            EmptyView()
        }
    }
}
