//
//  ContentView.swift
//  Aisland
//
//  Created by Aisland on 2026-02-15.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpanded = false
    @State private var hoverTimer: Timer?

    var body: some View {
        ZStack {
            if isExpanded {
                ExpandedView()
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
                    .onAppear {
                        WindowManager.shared.expandWindow()
                    }
            } else {
                NotchView()
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        WindowManager.shared.collapseWindow()
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpanded = true
                        }
                    }
            }
        }
        .background(Color.clear)
        .onHover { hovering in
            if hovering && !isExpanded {
                // Delay expansion on hover
                hoverTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        isExpanded = true
                    }
                }
            } else if !hovering && hoverTimer != nil {
                hoverTimer?.invalidate()
                hoverTimer = nil
            }
        }
        .onExitCommand {
            // ESC key to close
            if isExpanded {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    isExpanded = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 200, height: 32)
        .background(Color.black.opacity(0.1))
}
