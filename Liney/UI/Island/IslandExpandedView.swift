//
//  IslandExpandedView.swift
//  Liney
//
//  Author: everettjf
//

import SwiftUI

struct IslandExpandedView: View {
    @ObservedObject var state: IslandNotificationState
    let controller: IslandPanelController

    var body: some View {
        VStack(spacing: 0) {
            ForEach(state.items) { item in
                if let prompt = item.prompt {
                    IslandPromptRow(item: item, prompt: prompt, controller: controller)
                } else {
                    IslandItemRow(item: item, controller: controller)
                }

                if item.id != state.items.last?.id {
                    Divider()
                        .background(.white.opacity(0.1))
                }
            }
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.black.opacity(0.85))
        )
    }
}

private struct IslandItemRow: View {
    let item: IslandNotificationItem
    let controller: IslandPanelController

    var body: some View {
        Button {
            controller.navigateToItem(item)
        } label: {
            HStack(spacing: 10) {
                statusIndicator
                    .frame(width: 16)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    if item.status == .done {
                        Text("Done — click to jump")
                            .font(.system(size: 11))
                            .foregroundStyle(.green)
                    } else if let body = item.body {
                        Text(body)
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.5))
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 4)

                HStack(spacing: 6) {
                    if let agentName = item.agentName {
                        TagPill(text: agentName)
                    }
                    if let terminalTag = item.terminalTag {
                        TagPill(text: terminalTag)
                    }

                    Text(elapsedText)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var statusIndicator: some View {
        switch item.status {
        case .running:
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)
        case .done:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(.green)
        case .error:
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(.red)
        case .waitingForInput:
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(.cyan)
        }
    }

    private var elapsedText: String {
        let interval = Date().timeIntervalSince(item.startedAt)
        if interval < 60 {
            return "\(Int(interval))s"
        } else if interval < 3600 {
            return "\(Int(interval / 60))m"
        } else {
            return "\(Int(interval / 3600))h"
        }
    }
}

private struct IslandPromptRow: View {
    let item: IslandNotificationItem
    let prompt: IslandPrompt
    let controller: IslandPanelController

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundStyle(.cyan)
                Text("Claude asks")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.cyan)
                Spacer()
            }

            Text(prompt.question)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)

            ForEach(prompt.options) { option in
                Button {
                    controller.navigateToItem(item)
                } label: {
                    HStack(spacing: 8) {
                        Text("\u{2318}\(option.id)")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.white.opacity(0.1))
                            )

                        Text(option.label)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white)

                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.08))
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

private struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(.white.opacity(0.6))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(0.12))
            )
    }
}
