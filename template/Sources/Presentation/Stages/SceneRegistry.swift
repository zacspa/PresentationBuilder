import Foundation
import SwiftUI

/// Maps SceneID -> SceneSnapshot (element positions/states).
enum SceneRegistry {
    static func snapshot(for scene: SceneID) -> SceneSnapshot {
        switch scene {
        case .titleCard:        return titleCard
        case .closingCard:      return closingCard
        case .canvasIntro:      return canvasIntro
        case .canvasMove:       return canvasMove
        case .canvasTransform:  return canvasTransform
        case .layoutGrid:       return layoutGrid
        case .layoutCircle:     return layoutCircle
        case .layoutTree:       return layoutTree
        case .animationShowcase: return animationShowcase
        case .focusAll:         return focusAll
        case .focusCanvas:      return focusSingle("card-canvas")
        case .focusMorph:       return focusSingle("card-morph")
        case .focusAnimation:   return focusSingle("card-animation")
        case .focusInteractive: return focusSingle("card-interactive")
        case .focusAllReturn:   return focusAll
        }
    }

    // MARK: - Title Card

    private static let titleCard: SceneSnapshot = [
        "icon-hero": ElementState(
            position: CGPoint(x: 0.5, y: 0.28),
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
            position: CGPoint(x: 0.5, y: 0.26),
            opacity: 1.0, scale: 1.0
        ),
        "label-closing-title": ElementState(
            position: CGPoint(x: 0.5, y: 0.46),
            opacity: 1.0, scale: 1.0
        ),
        "label-closing-subtitle": ElementState(
            position: CGPoint(x: 0.5, y: 0.58),
            opacity: 1.0, scale: 1.0
        ),
    ]

    // MARK: - Canvas Demo (Slide 2)

    // Step 1: Three boxes in a horizontal row
    private static let canvasIntro: SceneSnapshot = [
        "canvas-box-a": ElementState(
            position: CGPoint(x: 0.25, y: 0.45),
            opacity: 1.0, scale: 1.0
        ),
        "canvas-box-b": ElementState(
            position: CGPoint(x: 0.50, y: 0.45),
            opacity: 1.0, scale: 1.0
        ),
        "canvas-box-c": ElementState(
            position: CGPoint(x: 0.75, y: 0.45),
            opacity: 1.0, scale: 1.0
        ),
        "canvas-label": ElementState(
            position: CGPoint(x: 0.50, y: 0.80),
            opacity: 1.0, scale: 1.0
        ),
    ]

    // Step 2: Boxes move to a vertical stack
    private static let canvasMove: SceneSnapshot = [
        "canvas-box-a": ElementState(
            position: CGPoint(x: 0.50, y: 0.25),
            opacity: 1.0, scale: 1.0
        ),
        "canvas-box-b": ElementState(
            position: CGPoint(x: 0.50, y: 0.47),
            opacity: 1.0, scale: 1.0
        ),
        "canvas-box-c": ElementState(
            position: CGPoint(x: 0.50, y: 0.69),
            opacity: 1.0, scale: 1.0
        ),
        "canvas-label": ElementState(
            position: CGPoint(x: 0.50, y: 0.90),
            opacity: 1.0, scale: 1.0
        ),
    ]

    // Step 3: Rotated and blurred composition
    private static let canvasTransform: SceneSnapshot = [
        "canvas-box-a": ElementState(
            position: CGPoint(x: 0.35, y: 0.35),
            opacity: 1.0, scale: 0.9,
            rotation: .degrees(-15), blur: 0, zIndex: 2
        ),
        "canvas-box-b": ElementState(
            position: CGPoint(x: 0.50, y: 0.50),
            opacity: 1.0, scale: 1.1,
            rotation: .degrees(0), blur: 0, zIndex: 3
        ),
        "canvas-box-c": ElementState(
            position: CGPoint(x: 0.65, y: 0.65),
            opacity: 0.7, scale: 0.8,
            rotation: .degrees(20), blur: 3, zIndex: 1
        ),
        "canvas-label": ElementState(
            position: CGPoint(x: 0.50, y: 0.90),
            opacity: 1.0, scale: 1.0
        ),
    ]

    // MARK: - Morphing Layouts (Slide 3)

    // Step 1: 3x2 grid
    private static let layoutGrid: SceneSnapshot = [
        "morph-0": ElementState(position: CGPoint(x: 0.30, y: 0.35), opacity: 1.0, scale: 1.0),
        "morph-1": ElementState(position: CGPoint(x: 0.50, y: 0.35), opacity: 1.0, scale: 1.0),
        "morph-2": ElementState(position: CGPoint(x: 0.70, y: 0.35), opacity: 1.0, scale: 1.0),
        "morph-3": ElementState(position: CGPoint(x: 0.30, y: 0.60), opacity: 1.0, scale: 1.0),
        "morph-4": ElementState(position: CGPoint(x: 0.50, y: 0.60), opacity: 1.0, scale: 1.0),
        "morph-5": ElementState(position: CGPoint(x: 0.70, y: 0.60), opacity: 1.0, scale: 1.0),
    ]

    // Step 2: Circle arrangement with rotation
    private static let layoutCircle: SceneSnapshot = {
        var snap: SceneSnapshot = [:]
        let center = CGPoint(x: 0.50, y: 0.48)
        let radius = 0.20
        for i in 0..<6 {
            let angle = Double(i) * (.pi * 2 / 6) - .pi / 2
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            snap["morph-\(i)"] = ElementState(
                position: CGPoint(x: x, y: y),
                opacity: 1.0, scale: 1.0,
                rotation: .degrees(Double(i) * 60)
            )
        }
        return snap
    }()

    // Step 3: Binary tree arrangement with scale hierarchy
    private static let layoutTree: SceneSnapshot = [
        // Root
        "morph-0": ElementState(position: CGPoint(x: 0.50, y: 0.22), opacity: 1.0, scale: 1.3),
        // Level 1
        "morph-1": ElementState(position: CGPoint(x: 0.32, y: 0.42), opacity: 1.0, scale: 1.0),
        "morph-2": ElementState(position: CGPoint(x: 0.68, y: 0.42), opacity: 1.0, scale: 1.0),
        // Level 2
        "morph-3": ElementState(position: CGPoint(x: 0.22, y: 0.62), opacity: 1.0, scale: 0.8),
        "morph-4": ElementState(position: CGPoint(x: 0.42, y: 0.62), opacity: 1.0, scale: 0.8),
        "morph-5": ElementState(position: CGPoint(x: 0.62, y: 0.62), opacity: 1.0, scale: 0.8),
    ]

    // MARK: - Continuous Animation (Slide 4)

    private static let animationShowcase: SceneSnapshot = [
        "orbiter": ElementState(
            position: CGPoint(x: 0.50, y: 0.48),
            opacity: 1.0, scale: 1.0
        ),
    ]

    // MARK: - Focus & Blur (Slide 5)

    // Step 1: All 4 cards in a 2x2 grid
    private static let focusAll: SceneSnapshot = [
        "card-canvas": ElementState(
            position: CGPoint(x: 0.35, y: 0.37),
            opacity: 1.0, scale: 1.0
        ),
        "card-morph": ElementState(
            position: CGPoint(x: 0.65, y: 0.37),
            opacity: 1.0, scale: 1.0
        ),
        "card-animation": ElementState(
            position: CGPoint(x: 0.35, y: 0.63),
            opacity: 1.0, scale: 1.0
        ),
        "card-interactive": ElementState(
            position: CGPoint(x: 0.65, y: 0.63),
            opacity: 1.0, scale: 1.0
        ),
    ]

    // Helper: one card zooms to center, the rest blur and fade
    private static let cardKeys = ["card-canvas", "card-morph", "card-animation", "card-interactive"]
    private static let cardPositions: [String: CGPoint] = [
        "card-canvas":      CGPoint(x: 0.35, y: 0.37),
        "card-morph":        CGPoint(x: 0.65, y: 0.37),
        "card-animation":    CGPoint(x: 0.35, y: 0.63),
        "card-interactive":  CGPoint(x: 0.65, y: 0.63),
    ]

    private static func focusSingle(_ focused: String) -> SceneSnapshot {
        var snap: SceneSnapshot = [:]
        for key in cardKeys {
            if key == focused {
                snap[key] = ElementState(
                    position: CGPoint(x: 0.50, y: 0.48),
                    opacity: 1.0, scale: 1.4, zIndex: 10
                )
            } else {
                snap[key] = ElementState(
                    position: cardPositions[key] ?? CGPoint(x: 0.5, y: 0.5),
                    opacity: 0.2, scale: 0.85, blur: 8
                )
            }
        }
        return snap
    }
}
