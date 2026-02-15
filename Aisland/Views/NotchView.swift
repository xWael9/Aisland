//
//  NotchView.swift
//  Aisland
//
//  Collapsed notch UI (compact mode)
//

import SwiftUI

struct NotchView: View {
    // MARK: - Properties

    let isHovering: Bool

    // MARK: - Animation Presets

    private let pulseAnimation = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    private let hoverAnimation = Animation.spring(response: 0.2, dampingFraction: 0.8)

    // MARK: - Environment

    @Environment(\.colorScheme) var colorScheme

    // MARK: - State

    @State private var isPulsing: Bool = false

    // MARK: - Body

    var body: some View {
        HStack(spacing: 8) {
            // Leading icon with pulse animation
            Image(systemName: "sparkles")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.blue.gradient)
                .opacity(isPulsing ? 0.6 : 1.0)
                .scaleEffect(isPulsing ? 0.95 : 1.0)
                .animation(pulseAnimation, value: isPulsing)

            // App name
            Text("Aisland")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.primary)

            // Status indicator
            Circle()
                .fill(statusColor.gradient)
                .frame(width: 6, height: 6)
                .shadow(color: statusColor.opacity(0.5), radius: isHovering ? 4 : 2)
                .animation(hoverAnimation, value: isHovering)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(backgroundMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(borderColor, lineWidth: 1)
        )
        .shadow(
            color: shadowColor,
            radius: isHovering ? 15 : 10,
            x: 0,
            y: isHovering ? 6 : 4
        )
        .scaleEffect(isHovering ? 1.05 : 1.0)
        .animation(hoverAnimation, value: isHovering)
        .onAppear {
            isPulsing = true
        }
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Aisland notch")
        .accessibilityHint("Click to expand widget dashboard")
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Computed Properties

    private var backgroundMaterial: some View {
        ZStack {
            // Ultra-thin material for subtle blur
            Color.clear
                .background(.ultraThinMaterial)

            // Slight tint overlay
            Color.accentColor
                .opacity(isHovering ? 0.05 : 0.02)
        }
    }

    private var borderColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(isHovering ? 0.15 : 0.1)
            : Color.black.opacity(isHovering ? 0.08 : 0.05)
    }

    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.3)
            : Color.black.opacity(0.1)
    }

    private var statusColor: Color {
        .green // Active status
    }
}

// MARK: - Preview

#Preview("Idle") {
    NotchView(isHovering: false)
        .frame(width: 200, height: 32)
        .background(Color.gray.opacity(0.3))
}

#Preview("Hovering") {
    NotchView(isHovering: true)
        .frame(width: 220, height: 36)
        .background(Color.gray.opacity(0.3))
}

#Preview("Dark Mode") {
    NotchView(isHovering: false)
        .frame(width: 200, height: 32)
        .background(Color.white.opacity(0.1))
        .preferredColorScheme(.dark)
}

#Preview("Light Mode") {
    NotchView(isHovering: false)
        .frame(width: 200, height: 32)
        .background(Color.black.opacity(0.1))
        .preferredColorScheme(.light)
}
