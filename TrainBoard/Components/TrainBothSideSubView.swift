//
//  TrainBothSideView.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 17/04/2026.
//
import SwiftUI

struct TrainBothSideView: View {
    let fromStaion: Station
    let toStation: Station
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center, spacing: 16) {
                stationBlock(
                    title: "From",
                    stationName: fromStaion.stationName,
                    crs: fromStaion.crs,
                    alignment: .leading
                )
                
                middleArrow
                
                stationBlock(
                    title: "To",
                    stationName: toStation.stationName,
                    crs: toStation.crs,
                    alignment: .trailing
                )
            }
            .padding(22)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 10)
            .padding()
        }
    }
    
    
    private func stationBlock(
        title: String,
        stationName: String,
        crs: String,
        alignment: HorizontalAlignment
    ) -> some View {
        VStack(alignment: alignment, spacing: 8) {
            Text(title.uppercased())
                .font(.caption2)
                .fontWeight(.semibold)
                .tracking(1.1)
                .foregroundStyle(.white.opacity(0.55))
            
            Text(stationName)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(alignment == .leading ? .leading : .trailing)
                .lineLimit(2)
            
            Text(crs)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.78))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.07))
                )
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : .trailing)
    }
    
    private var middleArrow: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 42, height: 42)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
            
            Image(systemName: "arrow.right")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}

#Preview {
    TrainBothSideView(
        fromStaion: Station(stationName: "London Victoria", crs: "VIC"),
        toStation: Station(stationName: "East Grinstead", crs: "EGD")
    )
}
