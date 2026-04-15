//
//  StatePanel.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 15/04/2026.
//

import SwiftUI

struct StatePanel<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let content: Content

    init(icon: String, title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)

            Text(title)
                .bold()

            Text(subtitle)
                .font(.caption)
                .opacity(0.7)

            content
        }
        .foregroundStyle(.white)
    }
}

