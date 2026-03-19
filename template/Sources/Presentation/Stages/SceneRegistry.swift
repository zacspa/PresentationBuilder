import Foundation
import SwiftUI

/// Maps SceneID -> SceneSnapshot (element positions/states).
/// This is the visual authoring surface — one case per scene.
///
/// To position an element:
/// - Use unit coordinates (0...1) for position
/// - (0.5, 0.5) is center, (0, 0) is top-left, (1, 1) is bottom-right
/// - Elements not mentioned in a snapshot default to hidden (opacity 0, scale 0.5)
enum SceneRegistry {
    static func snapshot(for scene: SceneID) -> SceneSnapshot {
        switch scene {
        case .titleCard:    return titleCard
        case .closingCard:  return closingCard
        case .overview:     return centered("diagram-overview")
        case .architecture: return centered("diagram-architecture")
        case .keyDecision:  return centered("diagram-keyDecision")
        case .demo:         return [:] // takeover — no canvas elements
        case .impact:       return centered("diagram-impact")
        }
    }

    /// Helper: a single composite element centered on stage.
    private static func centered(_ key: String) -> SceneSnapshot {
        [key: ElementState(position: CGPoint(x: 0.5, y: 0.5), opacity: 1.0, scale: 1.0)]
    }

    // MARK: - Title Card

    private static let titleCard: SceneSnapshot = [
        "icon-hero": ElementState(
            position: CGPoint(x: 0.5, y: 0.30),
            opacity: 1.0, scale: 1.0
        ),
        "label-title": ElementState(
            position: CGPoint(x: 0.5, y: 0.46),
            opacity: 1.0, scale: 1.0
        ),
        "label-subtitle": ElementState(
            position: CGPoint(x: 0.5, y: 0.56),
            opacity: 1.0, scale: 1.0
        ),
        "label-presenter": ElementState(
            position: CGPoint(x: 0.5, y: 0.68),
            opacity: 1.0, scale: 1.0
        ),
    ]

    // MARK: - Closing Card

    private static let closingCard: SceneSnapshot = [
        "icon-hero": ElementState(
            position: CGPoint(x: 0.5, y: 0.28),
            opacity: 1.0, scale: 1.0
        ),
        "label-closing-title": ElementState(
            position: CGPoint(x: 0.5, y: 0.48),
            opacity: 1.0, scale: 1.0
        ),
        "label-questions": ElementState(
            position: CGPoint(x: 0.5, y: 0.60),
            opacity: 1.0, scale: 1.0
        ),
    ]
}
