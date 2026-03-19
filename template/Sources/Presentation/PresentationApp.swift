import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
        }
    }
}

@main
struct PresentationApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var presentationState = PresentationState()

    var body: some Scene {
        Window("Presentation", id: "presentation") {
            PresentationView()
                .environment(presentationState)
        }
        .windowResizability(.contentMinSize)
        .defaultSize(width: 1440, height: 900)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }

        Window("Presenter Timer", id: "presenter-timer") {
            PresenterTimerView()
                .environment(presentationState)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 380, height: 500)
        .keyboardShortcut("t", modifiers: [.command])
    }
}
