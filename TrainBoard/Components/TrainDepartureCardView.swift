//
//  Teksldjfl.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 13/04/2026.
//

import SwiftUI

struct TrainDepartureCard: View {
    let service: TrainServices

    private var statusText: String {
        if service.isCancelled == true { return "Cancelled" }
        let etd = service.etd?.trimmingCharacters(in: .whitespaces) ?? ""
        return etd.isEmpty ? "On time" : etd
    }

    private var statusColor: Color {
        if service.isCancelled == true { return .red }
        if statusText.lowercased() == "on time" { return .green }
        return .orange
    }

    private var destination: String {
        service.destination.first?.locationName ?? "Unknown"
    }

    private var platform: String {
        let value = service.platform?.trimmingCharacters(in: .whitespaces) ?? ""
        return value.isEmpty ? "TBC" : value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text(service.std)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Spacer()

                Text(statusText)
                    .font(.caption.bold())
                    .foregroundStyle(statusColor)
            }

            Text(destination)
                .font(.headline)
                .foregroundStyle(.white)

            HStack {
                Text("Platform \(platform)")
                Spacer()
                Text(service.trainOperator)
            }
            .font(.caption)
            .foregroundStyle(.white.opacity(0.7))
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
#Preview {
    TrainDepartureCard(service:TrainServices(std: "4.50", trainOperator: "THAMES LINK", origin: [], destination: []))
}
