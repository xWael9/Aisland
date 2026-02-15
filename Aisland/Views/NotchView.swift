//
//  NotchView.swift
//  Aisland
//
//  Created by Aisland on 2026-02-15.
//

import SwiftUI

struct NotchView: View {
    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 8) {
            // Sparkles icon with pulsing animation
            Image(systemName: "sparkles")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(isPulsing ? 1.1 : 1.0)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: isPulsing
                )

            Text("Aisland")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            // Status indicator
            Circle()
                .fill(Color.green)
                .frame(width: 6, height: 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        .onAppear {
            isPulsing = true
        }
    }
}

#Preview {
    NotchView()
        .frame(width: 180, height: 32)
        .background(Color.black)
}
