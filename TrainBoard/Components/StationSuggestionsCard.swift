//
//  s.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 15/04/2026.
//

import SwiftUI


struct StationSuggestionsCard: View {
    let stations: [Station]
    let onSelect: (Station) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Suggested stations")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.65))
                .padding(.horizontal, 14)
                .padding(.top, 12)
                .padding(.bottom, 8)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(stations) { station in
                        Button {
                            onSelect(station)
                        } label: {
                            StationSuggestionRow(station: station)
                        }
                        .buttonStyle(StationSuggestionButtonStyle())

                        if station.id != stations.last?.id {
                            Divider()
                                .overlay(Color.white.opacity(0.06))
                                .padding(.leading, 14)
                        }
                    }
                }
            }
            .frame(maxHeight: 260)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 8)
    }
}


#Preview {
    StationSuggestionRow(station: Station(stationName: "Victoria", crs: "VIC"))
}
