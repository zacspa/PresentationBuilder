import SwiftUI

/// Secondary window showing elapsed time, current slide info, notes, and pacing.
/// Toggle with Cmd+T. Hidden from screen capture so the audience never sees it.
struct PresenterTimerView: View {
    @Environment(PresentationState.self) private var state

    var body: some View {
        @Bindable var state = state

        TimelineView(.periodic(from: .now, by: 1.0)) { _ in
            let elapsed = state.elapsed
            let totalBudget: TimeInterval = StoryArc.timeBudgets.last?.endTime ?? 25 * 60

            VStack(spacing: 0) {
                elapsedSection(elapsed: elapsed, totalBudget: totalBudget)
                Divider()
                currentSlideSection(elapsed: elapsed)
                notesSection
                Divider()
                upcomingSection
                Divider()
                controlsSection
            }
            .frame(width: 380)
        }
        .background(WindowAccessor())
    }

    // MARK: - Sections

    @ViewBuilder
    private func elapsedSection(elapsed: TimeInterval, totalBudget: TimeInterval) -> some View {
        let progress = min(elapsed / totalBudget, 1.0)

        VStack(spacing: 8) {
            HStack {
                Text("ELAPSED")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(formatTime(elapsed))
                    .font(.system(size: 36, weight: .medium, design: .monospaced))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.secondary.opacity(0.2))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor(fraction: progress))
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 8)

            HStack {
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    @ViewBuilder
    private func currentSlideSection(elapsed: TimeInterval) -> some View {
        let slide = state.activeSlide ?? StoryArc.slides[0]
        let slideIndex = StoryArc.slides.firstIndex(of: slide) ?? 0
        let budget = StoryArc.timeBudgets[slideIndex]
        let remaining = budget.endTime - elapsed

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("NOW")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
                Circle()
                    .fill(slide.dotColor)
                    .frame(width: 8, height: 8)
            }

            Text(slide.shortTitle)
                .font(.title2.bold())

            Text("Act \(budget.act): \(budget.actTitle) \u{2014} slide \(slideIndex + 1)/\(StoryArc.slides.count)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                Text("Budget:")
                    .font(.subheadline)
                if state.isRunning {
                    Text(remaining >= 0
                         ? "\(formatTime(abs(remaining))) remaining"
                         : "\(formatTime(abs(remaining))) over")
                        .font(.subheadline.bold())
                        .foregroundStyle(pacingColor(remaining: remaining))
                } else {
                    Text("\(formatTime(budget.endTime - budget.startTime)) allocated")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private var notesSection: some View {
        let slide = state.activeSlide ?? StoryArc.slides[0]

        if !slide.presenterNotes.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Text("NOTES")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Text(slide.presenterNotes)
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            Divider()
        }
    }

    @ViewBuilder
    private var upcomingSection: some View {
        let slide = state.activeSlide ?? StoryArc.slides[0]
        let slideIndex = StoryArc.slides.firstIndex(of: slide) ?? 0

        VStack(alignment: .leading, spacing: 8) {
            Text("UP NEXT")
                .font(.caption.bold())
                .foregroundStyle(.secondary)

            if slideIndex + 1 < StoryArc.slides.count {
                let next = StoryArc.slides[slideIndex + 1]
                HStack(spacing: 8) {
                    Circle().fill(next.dotColor).frame(width: 6, height: 6)
                    Text("NEXT: \(next.shortTitle)")
                        .font(.subheadline)
                }
            }

            if slideIndex + 2 < StoryArc.slides.count {
                let then = StoryArc.slides[slideIndex + 2]
                HStack(spacing: 8) {
                    Circle().fill(then.dotColor).frame(width: 6, height: 6)
                    Text("THEN: \(then.shortTitle)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            if slideIndex + 1 >= StoryArc.slides.count {
                Text("Last slide!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    @ViewBuilder
    private var controlsSection: some View {
        HStack(spacing: 16) {
            Button(state.isRunning ? "Pause" : "Start") {
                if state.isRunning {
                    state.isRunning = false
                } else {
                    if state.presentationStartTime == nil {
                        state.start()
                    } else {
                        state.isRunning = true
                    }
                }
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])

            Button("Reset") {
                state.reset()
            }
            .keyboardShortcut("r", modifiers: [.command, .shift])
        }
        .padding()
    }

    // MARK: - Helpers

    private func formatTime(_ interval: TimeInterval) -> String {
        let total = Int(abs(interval))
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    private func progressColor(fraction: Double) -> Color {
        if fraction < 0.8 { return .green }
        if fraction < 0.95 { return .yellow }
        return .red
    }

    private func pacingColor(remaining: TimeInterval) -> Color {
        if remaining > 30 { return .green }
        if remaining > -30 { return .yellow }
        return .red
    }
}
