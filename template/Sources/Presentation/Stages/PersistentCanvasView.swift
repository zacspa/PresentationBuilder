import SwiftUI

// MARK: - Environment Keys

private struct ActiveSceneKey: EnvironmentKey {
    static let defaultValue: SceneID? = nil
}

private struct StageSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var activeScene: SceneID? {
        get { self[ActiveSceneKey.self] }
        set { self[ActiveSceneKey.self] = newValue }
    }
    var stageSize: CGSize {
        get { self[StageSizeKey.self] }
        set { self[StageSizeKey.self] = newValue }
    }
}

/// The long-lived ZStack canvas. Elements persist across slides and animate
/// between states when the active scene changes.
///
/// Key behaviors:
/// - Elements entering a scene get spring animation with staggered delay
/// - Elements exiting get a fast ease-out with no delay
/// - The canvas is never destroyed — it lives for the entire presentation
struct PersistentCanvasView: View {
    let sceneID: SceneID?

    @State private var elementStates: [String: ElementState] = [:]
    @State private var currentScene: SceneID?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(ElementCatalog.allKeys, id: \.self) { key in
                    let state = elementStates[key] ?? .hidden
                    ElementCatalog.view(for: key)
                        .environment(\.activeScene, currentScene)
                        .environment(\.stageSize, geo.size)
                        .scaleEffect(state.scale)
                        .rotationEffect(state.rotation)
                        .blur(radius: state.blur)
                        .opacity(state.opacity)
                        .position(
                            x: state.position.x * geo.size.width,
                            y: state.position.y * geo.size.height
                        )
                        .zIndex(state.zIndex)
                        .animation(
                            elementAnimation(for: key),
                            value: state
                        )
                }
            }
        }
        .onChange(of: sceneID) { _, newScene in
            guard let scene = newScene else { return }
            currentScene = scene
            elementStates = resolvedStates(for: scene)
        }
        .onAppear {
            if let scene = sceneID {
                currentScene = scene
                elementStates = resolvedStates(for: scene)
            }
        }
    }

    // MARK: - Per-Element Animation

    private func elementAnimation(for key: String) -> Animation {
        guard let scene = currentScene else {
            return .easeInOut(duration: 0.4)
        }
        let snapshot = SceneRegistry.snapshot(for: scene)
        let visibleKeys = ElementCatalog.allKeys.filter {
            (snapshot[$0]?.opacity ?? 0) > 0
        }
        guard let index = visibleKeys.firstIndex(of: key) else {
            // Exiting — fast out, no delay
            return .easeOut(duration: 0.3)
        }
        // Entering — spring with stagger
        let stagger = Double(index) * 0.06
        return .spring(duration: 0.5, bounce: 0.12).delay(stagger)
    }

    // MARK: - State Resolution

    private func resolvedStates(for scene: SceneID) -> [String: ElementState] {
        let snapshot = SceneRegistry.snapshot(for: scene)
        var resolved: [String: ElementState] = [:]
        for key in ElementCatalog.allKeys {
            resolved[key] = snapshot[key] ?? .hidden
        }
        return resolved
    }
}
