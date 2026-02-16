//
//  AislandWindow.swift
//  Aisland
//
//  Custom NSPanel for notch integration
//

import Cocoa
import SwiftUI

class AislandWindow: NSPanel {

    init(contentRect: NSRect, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel, .fullSizeContentView],
            backing: backing,
            defer: flag
        )

        setupWindow()
    }

    private func setupWindow() {
        // CRITICAL: Set window level ABOVE menu bar to overlay the notch
        self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.statusWindow)) + 2)

        // Window behavior
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]

        // Appearance
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = false

        // Ignore mouse events on transparent areas
        self.ignoresMouseEvents = false

        // Keep window on top
        self.hidesOnDeactivate = false

        // Set content view
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
    }

    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return false
    }

    // Handle escape key
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { // ESC key
            NotificationCenter.default.post(name: NSNotification.Name("EscapeKeyPressed"), object: nil)
        } else {
            super.keyDown(with: event)
        }
    }

    /// Position window to overlay the notch area
    func positionAtNotch() {
        guard let screen = NSScreen.main else { return }

        let screenFrame = screen.frame
        let windowSize = self.frame.size

        // Position at the absolute top of the screen to overlay notch
        let x = (screenFrame.width - windowSize.width) / 2
        let y = screenFrame.maxY - windowSize.height

        self.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
