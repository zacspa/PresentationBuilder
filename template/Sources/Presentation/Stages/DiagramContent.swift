import SwiftUI

/// Diagram content views for use as canvas composite elements.
///
/// Two patterns for diagrams:
///
/// 1. **Static computed properties** — for simple diagrams:
///    ```
///    static var myDiagram: some View { ... }
///    ```
///
/// 2. **Nested View structs** — for animated diagrams that need state:
///    ```
///    struct MyAnimatedDiagram: View {
///        @Environment(\.activeScene) private var activeScene
///        @Environment(\.stageSize) private var stageSize
///        @State private var animationPhase = false
///        ...
///    }
///    ```
///
/// Animated diagrams can read `activeScene` to trigger animations when
/// they become visible, and `stageSize` to position things relative to
/// the full canvas.
enum DiagramContent {

    /// Reusable placeholder for diagrams not yet built.
    static func placeholder(title: String, subtitle: String) -> some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                .foregroundStyle(.secondary.opacity(0.4))
                .frame(width: 400, height: 260)
                .overlay {
                    VStack(spacing: 12) {
                        Image(systemName: "rectangle.3.group")
                            .font(.system(size: 36))
                            .foregroundStyle(.secondary.opacity(0.5))
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
        }
    }

    // MARK: - Example: Animated Diagram
    //
    // Uncomment and customize this as a starting point for animated diagrams.
    //
    // struct ExampleAnimatedView: View {
    //     @Environment(\.activeScene) private var activeScene
    //     @State private var phase = 0
    //
    //     var body: some View {
    //         VStack {
    //             Circle()
    //                 .fill(.blue)
    //                 .frame(width: 40, height: 40)
    //                 .offset(y: phase > 0 ? -100 : 0)
    //             Text("Phase: \(phase)")
    //         }
    //         .onChange(of: activeScene) { _, scene in
    //             // Trigger animation when this scene becomes active
    //             if scene == .someScene {
    //                 withAnimation(.spring(duration: 0.6)) {
    //                     phase = 1
    //                 }
    //             }
    //         }
    //     }
    // }
}
