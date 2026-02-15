//
//  AislandWindow.swift
//  Aisland
//
//  Created by Aisland on 2026-02-15.
//

import Cocoa
import SwiftUI

class AislandWindow: NSPanel {
    init(contentRect: NSRect, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView],
            backing: backing,
            defer: flag
        )

        // Window configuration
        self.isFloatingPanel = true
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = true
        self.standardWindowButton(.closeButton)?.isHidden = false
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true

        // Set appearance
        self.appearance = NSAppearance(named: .darkAqua)

        // Set content view
        setupContentView()
    }

    private func setupContentView() {
        let contentView = ContentView()
        let hostingView = NSHostingView(rootView: contentView)
        self.contentView = hostingView
    }

    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }

    /// Position window at the center of the screen
    func centerOnScreen() {
        if let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            let windowRect = self.frame
            let x = screenRect.midX - (windowRect.width / 2)
            let y = screenRect.midY - (windowRect.height / 2)
            self.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }

    /// Position window near the status bar item
    func positionNearStatusItem(_ statusItem: NSStatusItem) {
        guard let button = statusItem.button,
              let screen = button.window?.screen else {
            centerOnScreen()
            return
        }

        let buttonFrame = button.window?.convertToScreen(button.frame) ?? .zero
        let windowRect = self.frame

        // Position below the status item
        let x = buttonFrame.midX - (windowRect.width / 2)
        let y = buttonFrame.minY - windowRect.height - 8

        self.setFrameOrigin(NSPoint(x: x, y: y))

        // Ensure window is on screen
        if let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            var frame = self.frame

            if frame.maxX > screenRect.maxX {
                frame.origin.x = screenRect.maxX - frame.width
            }
            if frame.minX < screenRect.minX {
                frame.origin.x = screenRect.minX
            }
            if frame.minY < screenRect.minY {
                frame.origin.y = screenRect.minY
            }

            self.setFrame(frame, display: true)
        }
    }
}
