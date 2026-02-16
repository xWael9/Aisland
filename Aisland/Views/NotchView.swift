//
//  NotchView.swift
//  Aisland
//
//  Notch-integrated collapsed state
//

import SwiftUI

struct NotchView: View {
    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 6) {
            // Minimal sparkles icon
            Image(systemName: "sparkles")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(isPulsing ? 1.1 : 1.0)
                .animation(
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: isPulsing
                )

            Text("Aisland")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.7))

            // Tiny status indicator
            Circle()
                .fill(Color.green.opacity(0.8))
                .frame(width: 4, height: 4)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            // Dark background to blend with notch
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                )
        )
        .onAppear {
            isPulsing = true
        }
    }
}

#Preview {
    NotchView()
        .frame(width: 120, height: 24)
        .background(Color.black)
}
