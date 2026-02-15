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
    private let defaultWindowSize = NSRect(x: 0, y: 0, width: 800, height: 600)

    private init() {
        setupWindow()
    }

    private func setupWindow() {
        window = AislandWindow(
            contentRect: defaultWindowSize,
            backing: .buffered,
            defer: false
        )
        window?.centerOnScreen()
    }

    /// Show the Aisland window
    func showWindow() {
        guard let window = window else { return }

        if !window.isVisible {
            window.centerOnScreen()
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
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

    /// Position window near a status item
    func positionNearStatusItem(_ statusItem: NSStatusItem) {
        window?.positionNearStatusItem(statusItem)
    }

    /// Check if window is currently visible
    var isWindowVisible: Bool {
        return window?.isVisible ?? false
    }

    /// Update window size
    func setWindowSize(_ size: NSSize) {
        window?.setContentSize(size)
    }

    /// Get current window
    var currentWindow: AislandWindow? {
        return window
    }
}
