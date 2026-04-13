//
//  HeaderView.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 13/04/2026.
//

import SwiftUI

struct LiveBoardHeader: View {
    let locationName: String
    let crs: String
    
    var body: some View {
        ZStack{
            HStack(spacing: 14) {
                
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "tram.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(locationName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text(crs.uppercased())
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Capsule())
                        
                        Text("Live")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
                
                Spacer()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial.opacity(0.5))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.08))
            }
        }
    }
}

#Preview {
    LiveBoardHeader(locationName: "London Victoria", crs: "VIC")
}
