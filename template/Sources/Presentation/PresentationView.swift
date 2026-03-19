import SwiftUI

struct PresentationView: View {
    @Environment(PresentationState.self) private var state
    @StateObject private var nav = NavigationController()

    private var activeSlide: SlideDescriptor? {
        get { state.activeSlide }
    }

    var body: some View {
        @Bindable var state = state

        HStack(spacing: 0) {
            // Navigation scrubber
            SlideScrubber(activeSlide: $state.activeSlide)
                .frame(width: 36)

            Divider()

            // Narrative pane — scroll is the timeline
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(StoryArc.slides) { slide in
                        NarrativeSectionView(slide: slide, isActive: activeSlide == slide)
                            .containerRelativeFrame(.vertical)
                            .id(slide.id)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: Binding(
                get: { state.activeSlide?.id },
                set: { newID in
                    state.activeSlide = StoryArc.slides.first(where: { $0.id == newID })
                }
            ))
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .frame(minWidth: 400, idealWidth: 500)

            Divider()

            // Stage pane — persistent canvas + takeover overlay
            StageView(
                slide: activeSlide ?? StoryArc.slides[0],
                resolvedSceneID: state.currentSceneID
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(.windowBackgroundColor))
        .focusable()
        .onKeyPress(.downArrow) { .handled }
        .onKeyPress(.upArrow) { .handled }
        .onKeyPress(.space) { .handled }
        .onAppear {
            nav.advance = advance
            nav.retreat = retreat
            nav.isInteractive = { false }
            nav.install()
            updateNavInteractive()
        }
        .onDisappear { nav.uninstall() }
        .onChange(of: activeSlide) { _, _ in updateNavInteractive() }
        .onChange(of: state.sceneStep) { _, _ in updateNavInteractive() }
    }

    private func updateNavInteractive() {
        guard let slide = activeSlide else {
            nav.isInteractive = { false }
            return
        }
        if case .sceneThenTakeover = slide.stageContent {
            let step = state.sceneStep
            nav.isInteractive = { step > 0 }
        } else {
            let interactive = slide.isInteractive
            nav.isInteractive = { interactive }
        }
    }

    // MARK: - Navigation

    private func advance() {
        guard !nav.isTransitioning else { return }

        if state.hasNextStep {
            state.sceneStep += 1
            return
        }

        guard let current = activeSlide,
              let idx = StoryArc.slides.firstIndex(of: current),
              idx + 1 < StoryArc.slides.count else { return }
        navigateTo(StoryArc.slides[idx + 1])
    }

    private func retreat() {
        guard !nav.isTransitioning else { return }

        if state.hasPreviousStep {
            state.sceneStep -= 1
            return
        }

        guard let current = activeSlide,
              let idx = StoryArc.slides.firstIndex(of: current),
              idx > 0 else { return }
        let prevSlide = StoryArc.slides[idx - 1]
        navigateTo(prevSlide)
        let totalSteps = prevSlide.stageContent.stepCount
        if totalSteps > 1 {
            state.sceneStep = totalSteps - 1
        }
    }

    private func navigateTo(_ slide: SlideDescriptor) {
        nav.isTransitioning = true
        withAnimation(.easeInOut(duration: 0.3)) {
            state.activeSlide = slide
        }
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(250))
            nav.isTransitioning = false
        }
    }
}

// MARK: - Keyboard Navigation Controller

@MainActor
final class NavigationController: ObservableObject {
    var advance: () -> Void = {}
    var retreat: () -> Void = {}
    var isInteractive: () -> Bool = { false }
    var isTransitioning = false
    private var monitor: Any?

    func install() {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKey(event) ?? event
        }
    }

    func uninstall() {
        if let monitor { NSEvent.removeMonitor(monitor) }
        monitor = nil
    }

    private func handleKey(_ event: NSEvent) -> NSEvent? {
        if isInteractive() {
            switch Int(event.keyCode) {
            case 125: advance(); return nil  // down arrow
            case 126: retreat(); return nil   // up arrow
            case 53:  NSApp.terminate(nil); return nil  // escape
            default:  return event
            }
        }

        switch Int(event.keyCode) {
        case 125: advance(); return nil  // down arrow
        case 126: retreat(); return nil   // up arrow
        case 53:  NSApp.terminate(nil); return nil  // escape
        case 49:  advance(); return nil   // space
        default:  return event
        }
    }

    deinit {
        if let monitor { NSEvent.removeMonitor(monitor) }
    }
}
