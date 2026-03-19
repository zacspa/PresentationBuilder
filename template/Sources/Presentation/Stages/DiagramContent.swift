import SwiftUI

/// Diagram content views for the "SwiftUI: Beyond Static Slides" demo presentation.
enum DiagramContent {

    // MARK: - Slide 2: Canvas Box

    /// A gradient-filled rounded rect with an SF Symbol icon and label.
    static func canvasBox(color: Color, label: String, icon: String) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [color, color.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 90)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .shadow(color: color.opacity(0.4), radius: 12, y: 6)
            Text(label)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Slide 2: Canvas Explainer Label

    /// A label that updates its text based on the active scene step.
    struct CanvasExplainerLabel: View {
        @Environment(\.activeScene) private var activeScene

        var body: some View {
            Text(labelText)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
                .animation(.easeInOut(duration: 0.3), value: activeScene)
        }

        private var labelText: String {
            switch activeScene {
            case .canvasIntro:     return "Same elements — horizontal row"
            case .canvasMove:      return "Repositioned — vertical stack"
            case .canvasTransform: return "Rotated & blurred — same views!"
            default:               return "Persistent canvas demo"
            }
        }
    }

    // MARK: - Slide 3: Morph Node

    /// A colored numbered circle used for the 6-node layout morph.
    static func morphNode(index: Int) -> some View {
        let colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .purple]
        let color = colors[index % colors.count]
        return ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [color, color.opacity(0.7)],
                        center: .center,
                        startRadius: 0,
                        endRadius: 30
                    )
                )
                .frame(width: 56, height: 56)
                .shadow(color: color.opacity(0.5), radius: 8, y: 4)
            Text("\(index + 1)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    // MARK: - Slide 4: Orbiter View

    /// TimelineView-driven orbiter: 8 particles orbiting a hue-cycling center at 60fps.
    struct OrbiterView: View {
        @State private var hue: Double = 0

        private let particleCount = 8
        private let orbitRadius: CGFloat = 90

        var body: some View {
            TimelineView(.animation) { timeline in
                let now = timeline.date.timeIntervalSinceReferenceDate
                Canvas { context, size in
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)

                    // Center glow
                    let glowHue = now.truncatingRemainder(dividingBy: 6.0) / 6.0
                    let glowColor = Color(hue: glowHue, saturation: 0.8, brightness: 1.0)
                    for r in stride(from: 40.0, through: 8.0, by: -4.0) {
                        let opacity = 0.08 + (1.0 - r / 40.0) * 0.3
                        context.fill(
                            Path(ellipseIn: CGRect(
                                x: center.x - r, y: center.y - r,
                                width: r * 2, height: r * 2
                            )),
                            with: .color(glowColor.opacity(opacity))
                        )
                    }

                    // Orbiting particles
                    for i in 0..<particleCount {
                        let angle = (now * 0.8) + Double(i) * (.pi * 2 / Double(particleCount))
                        let px = center.x + cos(angle) * orbitRadius
                        let py = center.y + sin(angle) * orbitRadius
                        let particleHue = (glowHue + Double(i) * 0.12).truncatingRemainder(dividingBy: 1.0)
                        let particleColor = Color(hue: particleHue, saturation: 0.9, brightness: 1.0)

                        // Trail
                        for t in 1...4 {
                            let trailAngle = angle - Double(t) * 0.12
                            let tx = center.x + cos(trailAngle) * orbitRadius
                            let ty = center.y + sin(trailAngle) * orbitRadius
                            let trailSize: CGFloat = CGFloat(12 - t * 2)
                            let trailOpacity = 0.3 - Double(t) * 0.06
                            context.fill(
                                Path(ellipseIn: CGRect(
                                    x: tx - trailSize / 2, y: ty - trailSize / 2,
                                    width: trailSize, height: trailSize
                                )),
                                with: .color(particleColor.opacity(trailOpacity))
                            )
                        }

                        // Main particle
                        let size: CGFloat = 12
                        context.fill(
                            Path(ellipseIn: CGRect(
                                x: px - size / 2, y: py - size / 2,
                                width: size, height: size
                            )),
                            with: .color(particleColor.opacity(0.9))
                        )
                    }
                }
            }
            .frame(width: 280, height: 280)
        }
    }

    // MARK: - Slide 5: Feature Card

    /// A material card with an icon, title, and short description.
    static func featureCard(title: String, icon: String, color: Color, description: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            Text(description)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .padding(16)
        .frame(width: 220, height: 120, alignment: .topLeading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(color.opacity(0.3), lineWidth: 1)
        )
    }
}
