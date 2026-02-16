//
//  WindowManager.swift
//  Aisland
//
//  Manages notch-integrated window
//

import Cocoa
import SwiftUI

class WindowManager {
    static let shared = WindowManager()

    private var window: AislandWindow?

    // Collapsed size - small enough to sit IN the notch
    private let collapsedSize = NSSize(width: 120, height: 24)

    // Expanded size - drops down from notch
    private let expandedSize = NSSize(width: 780, height: 520)

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

        // Set SwiftUI content
        if let window = window {
            let contentView = NSHostingView(rootView: ContentView())
            contentView.wantsLayer = true
            contentView.layer?.backgroundColor = .clear
            window.contentView = contentView
        }

        // Position at notch
        window?.positionAtNotch()
    }

    /// Show the window
    func showWindow() {
        guard let window = window else { return }

        if !window.isVisible {
            window.positionAtNotch()
            window.orderFrontRegardless()
        }
    }

    /// Hide the window
    func hideWindow() {
        window?.orderOut(nil)
    }

    /// Toggle visibility
    func toggleWindow() {
        guard let window = window else { return }

        if window.isVisible {
            hideWindow()
        } else {
            showWindow()
        }
    }

    /// Expand window - drops down from notch
    func expandWindow() {
        guard let window = window,
              let screen = NSScreen.main else { return }

        let screenFrame = screen.frame

        // Center horizontally
        let x = (screenFrame.width - expandedSize.width) / 2
        // Drop down from top, leaving space for notch
        let y = screenFrame.maxY - expandedSize.height - 5

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.35
            context.timingFunction = CAMediaTimingFunction(controlPoints: 0.16, 1.0, 0.3, 1.0)
            window.animator().setFrame(
                NSRect(x: x, y: y, width: expandedSize.width, height: expandedSize.height),
                display: true
            )
        }
    }

    /// Collapse window - back to notch integration
    func collapseWindow() {
        guard let window = window,
              let screen = NSScreen.main else { return }

        let screenFrame = screen.frame
        let x = (screenFrame.width - collapsedSize.width) / 2
        let y = screenFrame.maxY - collapsedSize.height

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(controlPoints: 0.16, 1.0, 0.3, 1.0)
            window.animator().setFrame(
                NSRect(x: x, y: y, width: collapsedSize.width, height: collapsedSize.height),
                display: true
            )
        }
    }

    var isWindowVisible: Bool {
        return window?.isVisible ?? false
    }

    var currentWindow: AislandWindow? {
        return window
    }
}
