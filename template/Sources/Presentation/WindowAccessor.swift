import AppKit
import SwiftUI

/// Configures the hosting NSWindow to be hidden from screen capture and float above other windows.
/// Used by PresenterTimerView so the audience never sees your notes.
struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            window.sharingType = .none      // hidden from Zoom / screen recording
            window.level = .floating        // stays on top
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
