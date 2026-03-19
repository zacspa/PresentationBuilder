import Foundation
import SwiftUI

/// Shared presentation state, observed by both the main window and the presenter timer.
@Observable
@MainActor
final class PresentationState {
    var activeSlide: SlideDescriptor? = StoryArc.slides.first {
        didSet { sceneStep = 0 }
    }
    var sceneStep: Int = 0
    var presentationStartTime: Date?
    var isRunning: Bool = false

    /// The resolved SceneID for the current slide and step.
    var currentSceneID: SceneID? {
        guard let slide = activeSlide else { return nil }
        if case .sceneThenTakeover(let id, _, _) = slide.stageContent {
            return sceneStep == 0 ? id : nil
        }
        let steps = slide.stageContent.sceneSteps
        guard !steps.isEmpty else { return nil }
        return steps[min(sceneStep, steps.count - 1)]
    }

    var hasNextStep: Bool {
        guard let slide = activeSlide else { return false }
        return sceneStep + 1 < slide.stageContent.stepCount
    }

    var hasPreviousStep: Bool {
        sceneStep > 0
    }

    var elapsed: TimeInterval {
        guard let start = presentationStartTime, isRunning else { return 0 }
        return Date().timeIntervalSince(start)
    }

    func start() {
        presentationStartTime = Date()
        isRunning = true
    }

    func reset() {
        presentationStartTime = nil
        isRunning = false
    }
}
