//
//  WidgetCardView.swift
//  Aisland
//
//  Reusable widget card component
//

import SwiftUI

struct WidgetCardView: View {
    // MARK: - Properties

    let widget: WidgetModel
    let isHovered: Bool

    // MARK: - Constants

    private let cardHeight: CGFloat = 140
    private let iconSize: CGFloat = 24
    private let cornerRadius: CGFloat = 12

    // MARK: - Animation Presets

    private let hoverAnimation = Animation.spring(response: 0.2, dampingFraction: 0.8)

    // MARK: - Environment

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)

            // Content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
        .frame(height: cardHeight)
        .background(backgroundMaterial)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(borderColor, lineWidth: 1)
        )
        .shadow(
            color: shadowColor,
            radius: isHovered ? 15 : 10,
            x: 0,
            y: isHovered ? 6 : 4
        )
        .scaleEffect(isHovered && !reduceMotion ? 1.02 : 1.0)
        .animation(hoverAnimation, value: isHovered)
        .opacity(widget.isEnabled ? 1.0 : 0.5)
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(widget.name) widget")
        .accessibilityHint(widget.isEnabled ? "Double-click to open" : "Disabled")
        .accessibilityAddTraits(widget.isEnabled ? [.isButton] : [])
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 8) {
            // Widget icon
            Image(systemName: widget.icon)
                .font(.system(size: iconSize, weight: .medium))
                .foregroundStyle(widget.color.gradient)
                .frame(width: iconSize, height: iconSize)

            // Widget name
            Text(widget.name)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer()

            // Settings button
            if widget.isEnabled {
                Button(action: {
                    // TODO: Show widget settings
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
                .opacity(isHovered ? 1.0 : 0.0)
                .animation(hoverAnimation, value: isHovered)
                .accessibilityLabel("Widget settings")
            } else {
                // Disabled badge
                Text("Disabled")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(4)
            }
        }
    }

    // MARK: - Content

    private var content: some View {
        ZStack {
            if widget.isEnabled {
                // Active widget content
                VStack(spacing: 8) {
                    Spacer()

                    // Placeholder content
                    Image(systemName: widget.icon)
                        .font(.system(size: 40, weight: .light))
                        .foregroundStyle(widget.color.opacity(0.3))

                    Text("Widget Ready")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()
                }
            } else {
                // Disabled state
                VStack(spacing: 8) {
                    Spacer()

                    Image(systemName: "lock.fill")
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(.tertiary)

                    Text("Coming Soon")
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                    Spacer()
                }
            }

            // Footer info
            VStack {
                Spacer()

                if widget.isEnabled {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 8))
                            .foregroundStyle(.tertiary)

                        Text("Updated 2m ago")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)

                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: - Computed Properties

    private var backgroundMaterial: some View {
        ZStack {
            // Regular material for card background
            Color.clear
                .background(.regularMaterial)

            // Control background color with opacity
            Color(.controlBackgroundColor)
                .opacity(0.85)

            // Subtle color tint on hover
            if isHovered && widget.isEnabled {
                widget.color
                    .opacity(0.05)
            }
        }
    }

    private var borderColor: Color {
        if isHovered && widget.isEnabled {
            return widget.color.opacity(0.3)
        }

        return colorScheme == .dark
            ? Color.white.opacity(0.1)
            : Color.black.opacity(0.05)
    }

    private var shadowColor: Color {
        if isHovered && widget.isEnabled {
            return widget.color.opacity(0.2)
        }

        return colorScheme == .dark
            ? Color.black.opacity(0.3)
            : Color.black.opacity(0.1)
    }
}

// MARK: - Preview

#Preview("Enabled - Idle") {
    WidgetCardView(
        widget: WidgetModel(name: "Calendar", icon: "calendar", color: .red, isEnabled: true),
        isHovered: false
    )
    .frame(width: 200, height: 140)
    .padding()
    .background(Color.gray.opacity(0.2))
}

#Preview("Enabled - Hovering") {
    WidgetCardView(
        widget: WidgetModel(name: "Media", icon: "music.note", color: .pink, isEnabled: true),
        isHovered: true
    )
    .frame(width: 200, height: 140)
    .padding()
    .background(Color.gray.opacity(0.2))
}

#Preview("Disabled") {
    WidgetCardView(
        widget: WidgetModel(name: "Camera", icon: "camera.fill", color: .purple, isEnabled: false),
        isHovered: false
    )
    .frame(width: 200, height: 140)
    .padding()
    .background(Color.gray.opacity(0.2))
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
        WidgetCardView(
            widget: WidgetModel(name: "Calendar", icon: "calendar", color: .red, isEnabled: true),
            isHovered: false
        )

        WidgetCardView(
            widget: WidgetModel(name: "Notes", icon: "note.text", color: .yellow, isEnabled: true),
            isHovered: true
        )
    }
    .frame(width: 200)
    .padding()
    .background(Color.white.opacity(0.1))
    .preferredColorScheme(.dark)
}

#Preview("Light Mode") {
    VStack(spacing: 20) {
        WidgetCardView(
            widget: WidgetModel(name: "Calendar", icon: "calendar", color: .red, isEnabled: true),
            isHovered: false
        )

        WidgetCardView(
            widget: WidgetModel(name: "Notes", icon: "note.text", color: .yellow, isEnabled: true),
            isHovered: true
        )
    }
    .frame(width: 200)
    .padding()
    .background(Color.black.opacity(0.1))
    .preferredColorScheme(.light)
}

#Preview("Grid Layout") {
    LazyVGrid(
        columns: [GridItem(.adaptive(minimum: 180, maximum: 240), spacing: 16)],
        spacing: 16
    ) {
        ForEach(WidgetModel.sampleWidgets) { widget in
            WidgetCardView(widget: widget, isHovered: false)
        }
    }
    .padding(20)
    .background(Color.gray.opacity(0.2))
    .frame(width: 780)
}
