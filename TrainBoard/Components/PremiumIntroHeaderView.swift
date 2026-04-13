//
//  PremiumIntroHeaderView.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 13/04/2026.
//

import SwiftUI

struct PremiumIntroHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("TrainBoard")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)

            Text("Real-time UK train departures, simplified.")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.85))

            Text("Search by station code and instantly see platforms, delays, and destinations.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}


#Preview {
    PremiumIntroHeader()
}
