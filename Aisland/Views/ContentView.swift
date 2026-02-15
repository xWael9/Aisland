//
//  ContentView.swift
//  Aisland
//
//  Root view container managing notch state transitions
//

import SwiftUI

struct ContentView: View {
    // MARK: - State

    @State private var isExpanded: Bool = false
    @State private var isHovering: Bool = false
    @State private var hoverTimer: Timer?

    // MARK: - Constants

    private let hoverDelay: TimeInterval = 0.3

    // MARK: - Animation Presets

    private let snappySpring = Animation.spring(response: 0.3, dampingFraction: 0.8)
    private let smoothSpring = Animation.spring(response: 0.4, dampingFraction: 0.75)

    // MARK: - Environment

    @Environment(\.colorScheme) var colorScheme

    // MARK: - Body

    var body: some View {
        ZStack {
            if isExpanded {
                expandedView
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .scale(scale: 0.95).combined(with: .opacity)
                    ))
            } else {
                notchView
                    .transition(.asymmetric(
                        insertion: .scale(scale: 1.05).combined(with: .opacity),
                        removal: .scale(scale: 1.05).combined(with: .opacity)
                    ))
            }
        }
        .frame(
            width: isExpanded ? 780 : (isHovering ? 220 : 200),
            height: isExpanded ? 480 : (isHovering ? 36 : 32)
        )
        .animation(smoothSpring, value: isExpanded)
        .animation(snappySpring, value: isHovering)
        .onHover { hovering in
            handleHover(hovering)
        }
        .onTapGesture {
            toggleExpanded()
        }
    }

    // MARK: - Subviews

    private var notchView: some View {
        NotchView(isHovering: isHovering)
    }

    private var expandedView: some View {
        ExpandedView(isExpanded: $isExpanded)
    }

    // MARK: - Hover Handling

    private func handleHover(_ hovering: Bool) {
        hoverTimer?.invalidate()

        if hovering {
            hoverTimer = Timer.scheduledTimer(withTimeInterval: hoverDelay, repeats: false) { _ in
                withAnimation(smoothSpring) {
                    isHovering = true
                }
            }
        } else {
            withAnimation(snappySpring) {
                isHovering = false
            }

            // Auto-collapse if expanded and mouse leaves
            if isExpanded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !isHovering {
                        withAnimation(smoothSpring) {
                            isExpanded = false
                        }
                    }
                }
            }
        }
    }

    // MARK: - Actions

    private func toggleExpanded() {
        withAnimation(smoothSpring) {
            isExpanded.toggle()
        }
    }
}

// MARK: - Preview

#Preview("Collapsed") {
    ContentView()
        .frame(width: 200, height: 32)
        .background(Color.black.opacity(0.1))
}

#Preview("Hovering") {
    let view = ContentView()
    // Note: Can't directly set @State in preview, so this shows default state
    return view
        .frame(width: 220, height: 36)
        .background(Color.black.opacity(0.1))
}

#Preview("Expanded") {
    let view = ContentView()
    // Note: Can't directly set @State in preview, so this shows default state
    return view
        .frame(width: 780, height: 480)
        .background(Color.black.opacity(0.1))
}

#Preview("Dark Mode") {
    ContentView()
        .frame(width: 200, height: 32)
        .background(Color.white.opacity(0.1))
        .preferredColorScheme(.dark)
}
