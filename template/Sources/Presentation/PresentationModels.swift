import Foundation
import SwiftUI

// MARK: - Slide Descriptor

/// Each slide in the presentation. Edit StoryArc.slides to add/remove/reorder.
struct SlideDescriptor: Identifiable, Equatable {
    let id: String
    let shortTitle: String
    let narrativeTitle: String
    let narrativeBullets: [String]
    let stageContent: StageContent
    var presenterNotes: String = ""

    /// Color-coded dot for the scrubber. Customize per content type.
    var dotColor: Color {
        switch stageContent {
        case .scene(let sceneID):
            switch sceneID {
            case .titleCard, .closingCard: return .gray
            default:                       return .blue
            }
        case .scenes(let ids):
            if let first = ids.first {
                switch first {
                case .titleCard, .closingCard: return .gray
                default:                       return .blue
                }
            }
            return .blue
        case .takeover:
            return .green
        case .sceneThenTakeover(let sceneID, _, _):
            switch sceneID {
            case .titleCard, .closingCard: return .gray
            default:                       return .blue
            }
        }
    }

    var slideNumber: Int {
        (StoryArc.slides.firstIndex(where: { $0.id == id }) ?? 0) + 1
    }

    var isInteractive: Bool {
        if case .takeover = stageContent { return true }
        if case .sceneThenTakeover = stageContent { return true }
        return false
    }

    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}

// MARK: - Stage Content

/// What appears on the stage (right pane) for a given slide.
enum StageContent {
    /// A single scene on the persistent canvas.
    case scene(SceneID)
    /// Multiple scenes — advance through them with steps within the slide.
    case scenes([SceneID])
    /// A full-screen interactive overlay that replaces the canvas.
    case takeover(TakeoverType)
    /// Show a scene first, then transition to a takeover on the next step.
    case sceneThenTakeover(SceneID, TakeoverType, takeoverSteps: Int = 1)

    var sceneSteps: [SceneID] {
        switch self {
        case .scene(let id):                     return [id]
        case .scenes(let ids):                   return ids
        case .takeover:                          return []
        case .sceneThenTakeover(let id, _, _):   return [id]
        }
    }

    var stepCount: Int {
        switch self {
        case .scene:                           return 1
        case .scenes(let ids):                 return ids.count
        case .takeover:                        return 1
        case .sceneThenTakeover(_, _, let ts): return 1 + ts
        }
    }

    var takeoverType: TakeoverType? {
        switch self {
        case .takeover(let t):                  return t
        case .sceneThenTakeover(_, let t, _):   return t
        default:                                return nil
        }
    }
}

// MARK: - Scene ID

/// One case per visual moment on the persistent canvas.
/// Add new scenes here, then define their snapshot in SceneRegistry
/// and add any new elements to ElementCatalog.
enum SceneID: String, CaseIterable, Equatable, Hashable {
    // -- Bookend slides --
    case titleCard
    case closingCard
    // -- Content slides (add yours here) --
    case overview
    case architecture
    case keyDecision
    case demo
    case impact
}

// MARK: - Element State

/// Animatable properties for one element on the persistent canvas.
/// Positions use unit coordinates (0...1), mapped to actual size via GeometryReader.
struct ElementState: Equatable {
    var position: CGPoint = CGPoint(x: 0.5, y: 0.5)
    var opacity: Double = 1.0
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
    var blur: CGFloat = 0
    var zIndex: Double = 0
}

extension ElementState {
    /// Default state for elements not mentioned in a scene snapshot.
    static let hidden = ElementState(
        position: CGPoint(x: 0.5, y: 0.5),
        opacity: 0,
        scale: 0.5
    )
}

// MARK: - Scene Snapshot

/// Maps element keys to their states for a given scene.
typealias SceneSnapshot = [String: ElementState]

// MARK: - Takeover Type

/// Interactive overlays that replace the persistent canvas.
/// Add your own takeover types here (live demos, comparisons, etc.)
enum TakeoverType {
    case interactiveDemo
}
