//
//  AppDelegate.swift
//  Aisland
//
//  Created by Aisland on 2026-02-15.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var windowManager: WindowManager?
    var hoverDetector: HoverDetector?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide the app from the Dock
        NSApp.setActivationPolicy(.accessory)

        // Setup menu bar status item
        setupStatusItem()

        // Initialize window manager
        windowManager = WindowManager.shared

        // Initialize hover detector
        hoverDetector = HoverDetector()
        hoverDetector?.startMonitoring()
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Clean up
        hoverDetector?.stopMonitoring()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "Aisland")
            button.action = #selector(statusItemClicked)
            button.target = self
        }

        setupMenu()
    }

    private func setupMenu() {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Show Aisland", action: #selector(showWindow), keyEquivalent: "a"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Aisland", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    @objc private func statusItemClicked() {
        windowManager?.toggleWindow()
    }

    @objc private func showWindow() {
        windowManager?.showWindow()
    }

    @objc private func openPreferences() {
        // TODO: Implement preferences window
        print("Open preferences")
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
