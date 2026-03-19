import SwiftUI

/// The right pane: persistent canvas + optional takeover overlay.
///
/// When a slide has a takeover, the canvas fades out and the takeover fades in.
/// Both layers exist in a ZStack so the transition is smooth.
struct StageView: View {
    let slide: SlideDescriptor
    let resolvedSceneID: SceneID?

    private var activeScene: SceneID? {
        resolvedSceneID
    }

    private var activeTakeover: TakeoverType? {
        if case .takeover(let type) = slide.stageContent { return type }
        if case .sceneThenTakeover(_, let type, _) = slide.stageContent, resolvedSceneID == nil {
            return type
        }
        return nil
    }

    var body: some View {
        ZStack {
            // Layer 0: Persistent canvas — never destroyed
            PersistentCanvasView(sceneID: activeScene)
                .zIndex(0)
                .opacity(activeScene != nil ? 1.0 : 0.0)
                .allowsHitTesting(activeScene != nil)
                .animation(.easeInOut(duration: 0.35), value: activeScene == nil)

            // Layer 1: Takeover — fades in over the canvas
            if let takeover = activeTakeover {
                takeoverLayer(takeover)
                    .zIndex(1)
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }

    // MARK: - Takeover Layer

    @ViewBuilder
    private func takeoverLayer(_ takeover: TakeoverType) -> some View {
        switch takeover {
        case .interactiveDemo:
            // Replace with your interactive demo view
            VStack(spacing: 16) {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.green.opacity(0.6))
                Text("Interactive Demo")
                    .font(.title2.bold())
                Text("Replace this with your live demo view")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.windowBackgroundColor))
        }
    }
}
