//
//  WindowManager.swift
//  Aisland
//
//  Created by Aisland on 2026-02-15.
//

import Cocoa
import SwiftUI

class WindowManager {
    static let shared = WindowManager()

    private var window: AislandWindow?

    // Collapsed (notch integrated) size
    private let collapsedSize = NSSize(width: 180, height: 32)

    // Expanded (widget dashboard) size
    private let expandedSize = NSSize(width: 780, height: 480)

    private init() {
        setupWindow()
    }

    private func setupWindow() {
        // Start with collapsed size
        let initialRect = NSRect(origin: .zero, size: collapsedSize)

        window = AislandWindow(
            contentRect: initialRect,
            backing: .buffered,
            defer: false
        )

        // Position at notch immediately
        positionAtNotch()
    }

    /// Position window at the notch (top-center of screen)
    private func positionAtNotch() {
        guard let window = window,
              let screen = NSScreen.main else { return }

        let screenFrame = screen.frame
        let windowSize = window.frame.size

        // Calculate position: centered horizontally, at the very top
        let x = (screenFrame.width - windowSize.width) / 2
        let y = screenFrame.maxY - windowSize.height

        window.setFrameOrigin(NSPoint(x: x, y: y))
    }

    /// Show the Aisland window
    func showWindow() {
        guard let window = window else { return }

        if !window.isVisible {
            positionAtNotch()
            window.makeKeyAndOrderFront(nil)
        }
    }

    /// Hide the Aisland window
    func hideWindow() {
        window?.orderOut(nil)
    }

    /// Toggle window visibility
    func toggleWindow() {
        guard let window = window else { return }

        if window.isVisible {
            hideWindow()
        } else {
            showWindow()
        }
    }

    /// Expand window to show full widget dashboard
    func expandWindow() {
        guard let window = window,
              let screen = NSScreen.main else { return }

        let screenFrame = screen.frame

        // Calculate centered position for expanded view
        let x = (screenFrame.width - expandedSize.width) / 2
        // Position below the notch area
        let y = screenFrame.maxY - expandedSize.height - 40

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(
                NSRect(x: x, y: y, width: expandedSize.width, height: expandedSize.height),
                display: true
            )
        }
    }

    /// Collapse window to notch size
    func collapseWindow() {
        guard let window = window else { return }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            // Animate back to notch position
            let screen = NSScreen.main
            let screenFrame = screen?.frame ?? .zero
            let x = (screenFrame.width - collapsedSize.width) / 2
            let y = screenFrame.maxY - collapsedSize.height

            window.animator().setFrame(
                NSRect(x: x, y: y, width: collapsedSize.width, height: collapsedSize.height),
                display: true
            )
        }
    }

    /// Check if window is currently visible
    var isWindowVisible: Bool {
        return window?.isVisible ?? false
    }

    /// Get current window
    var currentWindow: AislandWindow? {
        return window
    }
}
