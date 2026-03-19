import SwiftUI

/// The right pane: persistent canvas + optional takeover overlay.
struct StageView: View {
    let slide: SlideDescriptor
    let resolvedSceneID: SceneID?

    private var activeScene: SceneID? {
        resolvedSceneID
    }

    private var activeTakeover: TakeoverType? {
        if case .takeover(let type) = slide.stageContent { return type }
        if case .sceneThenTakeover(_, let type, _) = slide.stageContent, resolvedSceneID == nil {
            return type
        }
        return nil
    }

    var body: some View {
        ZStack {
            PersistentCanvasView(sceneID: activeScene)
                .zIndex(0)
                .opacity(activeScene != nil ? 1.0 : 0.0)
                .allowsHitTesting(activeScene != nil)
                .animation(.easeInOut(duration: 0.35), value: activeScene == nil)

            if let takeover = activeTakeover {
                takeoverLayer(takeover)
                    .zIndex(1)
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }

    // MARK: - Takeover Layer

    @ViewBuilder
    private func takeoverLayer(_ takeover: TakeoverType) -> some View {
        switch takeover {
        case .particlePlayground:
            ParticlePlaygroundView()
        }
    }
}

// MARK: - Particle Simulation

/// Observable simulation state — physics runs on a DisplayLink timer, Canvas just reads positions.
@Observable
@MainActor
final class ParticleSimulation {
    struct Particle {
        var x: Double
        var y: Double
        var vx: Double
        var vy: Double
        var hue: Double
        var size: Double
    }

    var particles: [Particle] = []
    var attractors: [CGPoint] = []
    var mousePosition: CGPoint? = nil
    var tick: UInt64 = 0  // incremented each frame to trigger Canvas redraw

    private var displayLink: CVDisplayLink?
    private var viewSize: CGSize = .zero

    func initialize(in size: CGSize, count: Int = 150) {
        viewSize = size
        particles = (0..<count).map { i in
            Particle(
                x: Double.random(in: 0...size.width),
                y: Double.random(in: 0...size.height),
                vx: Double.random(in: -1...1),
                vy: Double.random(in: -1...1),
                hue: Double(i) / Double(count),
                size: Double.random(in: 3...8)
            )
        }
        startDisplayLink()
    }

    func stop() {
        if let link = displayLink {
            CVDisplayLinkStop(link)
            displayLink = nil
        }
    }

    private func startDisplayLink() {
        stop()
        var link: CVDisplayLink?
        CVDisplayLinkCreateWithActiveCGDisplays(&link)
        guard let link else { return }
        let selfPtr = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
        CVDisplayLinkSetOutputCallback(link, { _, _, _, _, _, userInfo -> CVReturn in
            guard let userInfo else { return kCVReturnSuccess }
            let sim = Unmanaged<ParticleSimulation>.fromOpaque(userInfo).takeUnretainedValue()
            DispatchQueue.main.async { sim.step() }
            return kCVReturnSuccess
        }, selfPtr)
        CVDisplayLinkStart(link)
        displayLink = link
    }

    private func step() {
        let size = viewSize
        guard !particles.isEmpty, size.width > 0 else { return }

        for i in particles.indices {
            // Mouse attraction — gentle, fades beyond 200px
            if let mouse = mousePosition {
                let dx = mouse.x - particles[i].x
                let dy = mouse.y - particles[i].y
                let dist = max(sqrt(dx * dx + dy * dy), 1)
                let force = 40.0 / (dist + 50.0)  // soft falloff, never too strong
                particles[i].vx += (dx / dist) * force
                particles[i].vy += (dy / dist) * force
            }

            // Pinned attractor forces — also gentle
            for attr in attractors {
                let adx = attr.x - particles[i].x
                let ady = attr.y - particles[i].y
                let adist = max(sqrt(adx * adx + ady * ady), 1)
                let aforce = 25.0 / (adist + 40.0)
                particles[i].vx += (adx / adist) * aforce
                particles[i].vy += (ady / adist) * aforce
            }

            // Random wandering — keeps particles lively
            particles[i].vx += Double.random(in: -0.4...0.4)
            particles[i].vy += Double.random(in: -0.4...0.4)

            // Damping
            particles[i].vx *= 0.92
            particles[i].vy *= 0.92

            // Integration
            particles[i].x += particles[i].vx
            particles[i].y += particles[i].vy

            // Wrap edges
            if particles[i].x < 0 { particles[i].x += size.width }
            if particles[i].x > size.width { particles[i].x -= size.width }
            if particles[i].y < 0 { particles[i].y += size.height }
            if particles[i].y > size.height { particles[i].y -= size.height }
        }
        tick &+= 1
    }

    nonisolated deinit {
    }
}

// MARK: - Particle Playground View

struct ParticlePlaygroundView: View {
    @State private var sim = ParticleSimulation()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.windowBackgroundColor)

                Canvas { context, size in
                    let _ = sim.tick  // observe tick so Canvas redraws
                    let hueShift = Double(sim.tick % 600) / 600.0

                    for p in sim.particles {
                        let hue = (p.hue + hueShift).truncatingRemainder(dividingBy: 1.0)
                        let color = Color(hue: hue, saturation: 0.85, brightness: 0.95)
                        let rect = CGRect(
                            x: p.x - p.size / 2,
                            y: p.y - p.size / 2,
                            width: p.size, height: p.size
                        )
                        context.fill(Path(ellipseIn: rect), with: .color(color.opacity(0.9)))
                    }

                    // Draw attractors
                    let pulse = Double(sim.tick % 60) / 60.0
                    let r = 8.0 + sin(pulse * .pi * 2) * 4.0
                    for attr in sim.attractors {
                        context.stroke(
                            Path(ellipseIn: CGRect(
                                x: attr.x - r, y: attr.y - r,
                                width: r * 2, height: r * 2
                            )),
                            with: .color(Color.white.opacity(0.5)),
                            lineWidth: 1.5
                        )
                        context.fill(
                            Path(ellipseIn: CGRect(
                                x: attr.x - 3, y: attr.y - 3,
                                width: 6, height: 6
                            )),
                            with: .color(Color.white.opacity(0.7))
                        )
                    }
                }
                .allowsHitTesting(false)

                // Mouse tracking overlay
                TrackingAreaView(
                    onMove: { point in sim.mousePosition = point },
                    onClick: { point in sim.attractors.append(point) }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                sim.initialize(in: geo.size)
            }
            .onDisappear {
                sim.stop()
            }
            .onChange(of: geo.size) { _, newSize in
                if sim.particles.isEmpty {
                    sim.initialize(in: newSize)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - NSView Tracking Area

/// An NSViewRepresentable that tracks mouse movement and clicks within the view.
struct TrackingAreaView: NSViewRepresentable {
    let onMove: (CGPoint) -> Void
    let onClick: (CGPoint) -> Void

    func makeNSView(context: Context) -> TrackingNSView {
        let view = TrackingNSView()
        view.onMove = onMove
        view.onClick = onClick
        return view
    }

    func updateNSView(_ nsView: TrackingNSView, context: Context) {
        nsView.onMove = onMove
        nsView.onClick = onClick
    }

    class TrackingNSView: NSView {
        var onMove: ((CGPoint) -> Void)?
        var onClick: ((CGPoint) -> Void)?
        private var trackingArea: NSTrackingArea?

        override var acceptsFirstResponder: Bool { true }

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            window?.acceptsMouseMovedEvents = true
            window?.makeFirstResponder(self)
        }

        override func updateTrackingAreas() {
            super.updateTrackingAreas()
            if let existing = trackingArea {
                removeTrackingArea(existing)
            }
            let area = NSTrackingArea(
                rect: bounds,
                options: [.mouseMoved, .mouseEnteredAndExited, .activeAlways, .inVisibleRect],
                owner: self,
                userInfo: nil
            )
            addTrackingArea(area)
            trackingArea = area
        }

        override func mouseMoved(with event: NSEvent) {
            let point = convert(event.locationInWindow, from: nil)
            let flipped = CGPoint(x: point.x, y: bounds.height - point.y)
            onMove?(flipped)
        }

        override func mouseDragged(with event: NSEvent) {
            let point = convert(event.locationInWindow, from: nil)
            let flipped = CGPoint(x: point.x, y: bounds.height - point.y)
            onMove?(flipped)
        }

        override func mouseDown(with event: NSEvent) {
            let point = convert(event.locationInWindow, from: nil)
            let flipped = CGPoint(x: point.x, y: bounds.height - point.y)
            onClick?(flipped)
        }
    }
}
