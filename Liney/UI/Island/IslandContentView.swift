//
//  IslandContentView.swift
//  Liney
//
//  Author: everettjf
//

import SwiftUI

struct IslandContentView: View {
    @ObservedObject var state: IslandNotificationState
    let controller: IslandPanelController

    var body: some View {
        Group {
            if state.isExpanded {
                IslandExpandedView(state: state, controller: controller)
            } else {
                IslandCollapsedView(state: state)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            state.isExpanded.toggle()
            controller.repositionPanel()
        }
    }
}
