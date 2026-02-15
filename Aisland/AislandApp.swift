//
//  AislandApp.swift
//  Aisland
//
//  Created by Aisland on 2026-02-15.
//

import SwiftUI

@main
struct AislandApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
