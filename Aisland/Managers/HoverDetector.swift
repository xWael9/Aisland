//
//  HoverDetector.swift
//  Aisland
//
//  Created by Aisland on 2026-02-15.
//

import Cocoa
import Foundation

class HoverDetector {
    private var eventMonitor: Any?
    private var isMonitoring = false
    private var lastMouseLocation: NSPoint = .zero
    private var hoverTimer: Timer?
    private let hoverDelay: TimeInterval = 0.5 // seconds

    /// Start monitoring mouse movement
    func startMonitoring() {
        guard !isMonitoring else { return }

        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
            self?.handleMouseMoved(event)
        }

        // Also monitor local events
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
            self?.handleMouseMoved(event)
            return event
        }

        isMonitoring = true
    }

    /// Stop monitoring mouse movement
    func stopMonitoring() {
        guard isMonitoring else { return }

        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }

        hoverTimer?.invalidate()
        hoverTimer = nil
        isMonitoring = false
    }

    private func handleMouseMoved(_ event: NSEvent) {
        let currentLocation = NSEvent.mouseLocation

        // Cancel previous timer
        hoverTimer?.invalidate()

        // Store current location
        lastMouseLocation = currentLocation

        // Start new hover timer
        hoverTimer = Timer.scheduledTimer(withTimeInterval: hoverDelay, repeats: false) { [weak self] _ in
            self?.handleHover(at: currentLocation)
        }
    }

    private func handleHover(at location: NSPoint) {
        // Detect if mouse is hovering over text or specific UI elements
        detectTextUnderCursor(at: location)
    }

    private func detectTextUnderCursor(at location: NSPoint) {
        // Get the window under the cursor
        let windowNumber = NSWindow.windowNumber(at: location, belowWindowWithWindowNumber: 0)
        guard windowNumber != 0 else {
            return
        }

        // TODO: Implement text detection using Accessibility API
        // This will require NSAppleEventsUsageDescription permission
        // and will be implemented in future iterations

        // For now, just log the location
        #if DEBUG
        print("Hover detected at: \(location)")
        #endif
    }

    /// Get text selection from frontmost application
    func getSelectedText() -> String? {
        // Get the frontmost app
        guard NSWorkspace.shared.frontmostApplication != nil else {
            return nil
        }

        // TODO: Use Accessibility API to get selected text
        // This requires proper permissions and AX API integration

        return nil
    }

    /// Check if a specific point contains text
    func hasTextAtPoint(_ point: NSPoint) -> Bool {
        // TODO: Implement using Accessibility API
        return false
    }
}
