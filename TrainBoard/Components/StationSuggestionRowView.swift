//
//  StationSuggestionRowView.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 15/04/2026.
//

import SwiftUI

struct StationSuggestionRow: View {
    let station: Station
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 42, height: 42)

                Image(systemName: "tram.fill")
                    .foregroundStyle(.white.opacity(0.85))
                    .font(.system(size: 16, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(station.stationName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                Text(station.crs)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.58))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.35))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
  StationSuggestionRow(station: Station(stationName: "london Bridge", crs: "LDG"))
}
