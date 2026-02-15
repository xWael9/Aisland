//
//  ExpandedView.swift
//  Aisland
//
//  Full widget dashboard grid
//

import SwiftUI

struct ExpandedView: View {
    // MARK: - Properties

    @Binding var isExpanded: Bool

    // MARK: - State

    @State private var widgets: [WidgetModel] = WidgetModel.sampleWidgets
    @State private var hoveredWidgetId: UUID?

    // MARK: - Constants

    private let gridSpacing: CGFloat = 16
    private let gridPadding: CGFloat = 20
    private let columns = [
        GridItem(.adaptive(minimum: 180, maximum: 240), spacing: 16)
    ]

    // MARK: - Environment

    @Environment(\.colorScheme) var colorScheme

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
                .padding(.horizontal, gridPadding)
                .padding(.top, 16)
                .padding(.bottom, 12)

            // Widget Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: gridSpacing) {
                    ForEach(widgets) { widget in
                        WidgetCardView(
                            widget: widget,
                            isHovered: hoveredWidgetId == widget.id
                        )
                        .onHover { hovering in
                            hoveredWidgetId = hovering ? widget.id : nil
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(gridPadding)
            }
        }
        .background(backgroundMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(borderColor, lineWidth: 1)
        )
        .shadow(color: shadowColor, radius: 20, x: 0, y: 10)
        // Accessibility
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Widget dashboard")
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            // Title
            HStack(spacing: 8) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.blue.gradient)

                Text("Widgets")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }

            Spacer()

            // Action buttons
            HStack(spacing: 12) {
                // Settings button
                Button(action: {
                    // TODO: Show settings
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Settings")

                // Close button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        isExpanded = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close dashboard")
                .keyboardShortcut(.escape, modifiers: [])
            }
        }
    }

    // MARK: - Computed Properties

    private var backgroundMaterial: some View {
        ZStack {
            // Regular material for solid blur
            Color.clear
                .background(.regularMaterial)

            // Subtle gradient overlay
            LinearGradient(
                colors: [
                    Color.accentColor.opacity(0.03),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private var borderColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.1)
            : Color.black.opacity(0.05)
    }

    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.4)
            : Color.black.opacity(0.15)
    }
}

// MARK: - Widget Model

struct WidgetModel: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let isEnabled: Bool

    static let sampleWidgets: [WidgetModel] = [
        WidgetModel(name: "Calendar", icon: "calendar", color: .red, isEnabled: true),
        WidgetModel(name: "Media", icon: "music.note", color: .pink, isEnabled: true),
        WidgetModel(name: "Quick Apps", icon: "square.grid.2x2", color: .blue, isEnabled: true),
        WidgetModel(name: "Notes", icon: "note.text", color: .yellow, isEnabled: true),
        WidgetModel(name: "Camera", icon: "camera.fill", color: .purple, isEnabled: false),
        WidgetModel(name: "Shortcuts", icon: "command", color: .orange, isEnabled: false),
        WidgetModel(name: "Bluetooth", icon: "antenna.radiowaves.left.and.right", color: .cyan, isEnabled: false),
    ]
}

// MARK: - Preview

#Preview("Expanded") {
    ExpandedView(isExpanded: .constant(true))
        .frame(width: 780, height: 480)
        .background(Color.black.opacity(0.1))
}

#Preview("Dark Mode") {
    ExpandedView(isExpanded: .constant(true))
        .frame(width: 780, height: 480)
        .background(Color.white.opacity(0.1))
        .preferredColorScheme(.dark)
}

#Preview("Light Mode") {
    ExpandedView(isExpanded: .constant(true))
        .frame(width: 780, height: 480)
        .background(Color.black.opacity(0.1))
        .preferredColorScheme(.light)
}
