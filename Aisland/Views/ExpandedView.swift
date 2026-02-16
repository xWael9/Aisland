//
//  ExpandedView.swift
//  Aisland
//
//  Created by Aisland on 2026-02-15.
//

import SwiftUI

struct ExpandedView: View {
    @Environment(\.colorScheme) private var colorScheme

    let onClose: () -> Void

    // Sample widget data
    private let widgets: [(icon: String, title: String, color: Color)] = [
        ("calendar", "Calendar", .red),
        ("music.note", "Media", .pink),
        ("square.grid.2x2", "Quick Apps", .blue),
        ("note.text", "Notes", .yellow),
        ("camera", "Camera", .purple),
        ("command", "Shortcuts", .orange),
        ("antenna.radiowaves.left.and.right", "Bluetooth", .cyan)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Widgets")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)

                Spacer()

                HStack(spacing: 12) {
                    Button(action: {
                        // TODO: Show settings
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)

                    Button(action: {
                        onClose()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.escape, modifiers: [])
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 16)

            Divider()
                .opacity(0.1)

            // Widget Grid
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 230, maximum: 250), spacing: 16)
                    ],
                    spacing: 16
                ) {
                    ForEach(widgets.indices, id: \.self) { index in
                        WidgetCard(
                            icon: widgets[index].icon,
                            title: widgets[index].title,
                            color: widgets[index].color
                        )
                    }
                }
                .padding(24)
            }
        }
        .frame(width: 780, height: 480)
        .background(
            ZStack {
                // Base material
                Rectangle()
                    .fill(.regularMaterial)

                // Subtle gradient overlay
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.02),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.4), radius: 30, y: 15)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct WidgetCard: View {
    let icon: String
    let title: String
    let color: Color

    @State private var isHovered = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.15))
                    .cornerRadius(10)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(width: 28, height: 28)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)

            Spacer()

            // Content area
            VStack(alignment: .leading, spacing: 4) {
                Text("Widget Ready")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)

                Text("Updated 2m ago")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .frame(height: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(nsColor: .controlBackgroundColor))
                .opacity(0.5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .scaleEffect(isHovered ? 1.03 : 1.0)
        .shadow(color: .black.opacity(isHovered ? 0.2 : 0.1), radius: isHovered ? 12 : 6, y: isHovered ? 6 : 3)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    ExpandedView(onClose: {})
        .preferredColorScheme(.dark)
}
