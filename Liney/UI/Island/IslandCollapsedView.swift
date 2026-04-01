//
//  IslandCollapsedView.swift
//  Liney
//
//  Author: everettjf
//

import SwiftUI

struct IslandCollapsedView: View {
    @ObservedObject var state: IslandNotificationState

    var body: some View {
        HStack(spacing: 8) {
            if let item = state.latestItem {
                statusIcon(for: item)
                    .font(.system(size: 14))

                Text(item.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer(minLength: 4)

                if state.badgeCount > 1 {
                    Text("\(state.badgeCount)")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.white.opacity(0.15))
                        )
                }
            } else {
                Text("No notifications")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.black.opacity(0.85))
        )
    }

    @ViewBuilder
    private func statusIcon(for item: IslandNotificationItem) -> some View {
        switch item.status {
        case .running:
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)
        case .done:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .error:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
        case .waitingForInput:
            Image(systemName: "questionmark.circle.fill")
                .foregroundStyle(.cyan)
        }
    }
}
