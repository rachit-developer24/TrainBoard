//
//  PremiumIntroHeaderView.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 13/04/2026.
//

import SwiftUI

struct PremiumIntroHeader: View {
    @State private var animateTrain = false
    @State private var pulseLive = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            topRow

            VStack(alignment: .leading, spacing: 6) {
                Text("TrainBoard")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)

                Text("Real-time UK train departures, simplified.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.82))
                    .lineLimit(2)

                Text("Search by station code to see live times, platforms, and delays.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.58))
                    .lineLimit(2)
            }

            animatedJourneyStrip
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 8)
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                animateTrain = true
            }

            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                pulseLive = true
            }
        }
    }
}

private extension PremiumIntroHeader {
    var topRow: some View {
        HStack {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(.green.opacity(0.22))
                        .frame(width: 14, height: 14)
                        .scaleEffect(pulseLive ? 1.25 : 0.85)
                        .opacity(pulseLive ? 0.18 : 0.4)

                    Circle()
                        .fill(.green)
                        .frame(width: 7, height: 7)
                }

                Text("LIVE UK RAIL")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .tracking(1)
                    .foregroundStyle(.white.opacity(0.75))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.06))
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 34, height: 34)
                    .overlay {
                        Circle()
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    }

                Image(systemName: "tram.fill")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
    }

    var animatedJourneyStrip: some View {
        GeometryReader { geo in
            let width = geo.size.width

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    }

                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 3)
                    .padding(.horizontal, 16)

                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 7, height: 7)

                    Spacer()

                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 7, height: 7)
                }
                .padding(.horizontal, 16)

                HStack {
                    Text("From")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))

                    Spacer()

                    Text("Live Departures")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.horizontal, 16)
                .padding(.top, 28)

                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 28, height: 28)
                        .blur(radius: 2)

                    Image(systemName: "train.side.front.car")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
                .offset(x: animateTrain ? max(width - 58, 0) : 16, y: -8)
            }
        }
        .frame(height: 62)
    }
}

#Preview {
    ZStack {
        ElegantBackground()
        PremiumIntroHeader()
            .padding()
    }
}
