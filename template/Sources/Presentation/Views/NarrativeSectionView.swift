import SwiftUI

/// One full-viewport-height section in the narrative (left) pane.
/// Bullets stagger in when the slide becomes active.
struct NarrativeSectionView: View {
    let slide: SlideDescriptor
    let isActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            VStack(alignment: .leading, spacing: 24) {
                // Slide counter
                HStack(spacing: 8) {
                    Text("\(slide.slideNumber)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(slide.dotColor.opacity(0.15))
                    Text("/ \(StoryArc.slides.count)")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundStyle(.quaternary)
                }

                // Title
                Text(slide.narrativeTitle)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                // Bullet points — stagger in when active
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(Array(slide.narrativeBullets.enumerated()), id: \.offset) { idx, bullet in
                        HStack(alignment: .top, spacing: 12) {
                            Circle()
                                .fill(slide.dotColor.opacity(0.6))
                                .frame(width: 6, height: 6)
                                .padding(.top, 7)
                            Text(bullet)
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .opacity(isActive ? 1.0 : 0.3)
                        .offset(x: isActive ? 0 : -8)
                        .animation(
                            .easeOut(duration: 0.35).delay(Double(idx) * 0.1),
                            value: isActive
                        )
                    }
                }

                // Hint for interactive slides
                if slide.isInteractive && isActive {
                    HStack(spacing: 6) {
                        Image(systemName: "hand.point.up.left.fill")
                            .font(.system(size: 11))
                        Text("Interactive — click into the stage pane")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(.tertiary)
                    .padding(.top, 8)
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, 48)

            Spacer()

            // Progress bar
            GeometryReader { geo in
                let progress = CGFloat(slide.slideNumber) / CGFloat(StoryArc.slides.count)
                Rectangle()
                    .fill(slide.dotColor.opacity(0.3))
                    .frame(width: geo.size.width * progress, height: 2)
            }
            .frame(height: 2)
        }
    }
}
