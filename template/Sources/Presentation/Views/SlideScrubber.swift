import SwiftUI

/// Vertical dot navigation bar on the left edge.
/// Each dot is color-coded by slide type and enlarges when active.
struct SlideScrubber: View {
    @Binding var activeSlide: SlideDescriptor?

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ForEach(StoryArc.slides, id: \.id) { slide in
                let isActive = activeSlide == slide
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        activeSlide = slide
                    }
                } label: {
                    Circle()
                        .fill(isActive ? slide.dotColor : slide.dotColor.opacity(0.25))
                        .frame(width: isActive ? 10 : 6, height: isActive ? 10 : 6)
                        .frame(width: 36, height: 28)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .help(slide.shortTitle)
                .animation(.easeOut(duration: 0.2), value: isActive)
            }
            Spacer()
        }
        .frame(width: 36)
        .background(Color(.windowBackgroundColor).opacity(0.5))
    }
}
