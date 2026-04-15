//
//  s.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 15/04/2026.
//

import SwiftUI

struct QuickCodeChip: View {
    let code: String
    var body: some View {
        Text(code)
            .font(.caption.bold())
            .padding(8)
            .background(Color.white.opacity(0.1))
            .clipShape(Capsule())
    }
}


