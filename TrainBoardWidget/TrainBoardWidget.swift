//
//  TrainBoardWidget.swift
//  TrainBoardWidget
//
//  Created by Rachit Sharma on 20/04/2026.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TrainEntry {
        TrainEntry(date: Date(), fromStation: "East Grinstead", toStation: "London Victoria", departureTime: "14.27", status: "On time",platForm: "3", lastUpdated: Date(), errorMessage: nil, isEmpty: false)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> TrainEntry {
        TrainEntry(date: Date(), fromStation: "East Grinstead", toStation: "London Victoria", departureTime: "14.27", status: "On time",platForm: "3", lastUpdated: Date(), errorMessage: nil, isEmpty: false)
    }
    
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<TrainEntry> {
        do {
            let service = FetchTrainService()
            let train = try await service.fetchTrainsForBothSide(fromCrs: "EGR", toCrs: "VIC")
            let services = train.trainServices
            if services == nil || services?.isEmpty == true{
                let entry = TrainEntry(date: Date(), fromStation: "East Grinstead", toStation: "London Victoria", departureTime: "", status: "No Train", platForm: nil, lastUpdated: Date(), errorMessage:nil, isEmpty: true)
                return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(300)))
            }else{
                let trainService = train.trainServices?.first
                let entry = TrainEntry(
                    date: Date(),
                    fromStation: "East Grinstead",
                    toStation: "London Victoria",
                    departureTime: trainService?.std ?? "--",
                    status: trainService?.etd ?? "Unknown",
                    platForm: trainService?.platform,
                    lastUpdated: Date(),
                    errorMessage: nil,
                    isEmpty: false
                )
                
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 40, to: Date()) ?? Date().addingTimeInterval(300)
                return Timeline(entries: [entry], policy: .after(nextUpdate))
            }
        } catch {
            let errorEntry = TrainEntry(
                date: Date(),
                fromStation: "",
                toStation: "",
                departureTime: "--",
                status: "Error",
                platForm: nil,
                lastUpdated: Date(),
                errorMessage: error.localizedDescription,
                isEmpty: false
            )
            return Timeline(entries: [errorEntry], policy: .after(Date().addingTimeInterval(300)))
        }
       
    }
}
    struct TrainEntry: TimelineEntry {
        let date: Date
        let fromStation:String
        let toStation:String
        let departureTime:String
        let status:String
        let platForm:String?
        let lastUpdated:Date
        let errorMessage:String?
        let isEmpty:Bool?
    }
    
    
    struct TrainBoardWidgetEntryView: View {
        let entry: Provider.Entry
        
        var color: Color {
            if entry.status == "On time" {
                return .green.opacity(0.85)
            } else if entry.status == "Cancelled" {
                return .red
            } else {
                return .yellow
            }
        }
        
        var body: some View {
            Group {
                if let error = entry.errorMessage {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title3)
                            .foregroundStyle(.yellow)
                        
                        Text("Live Error")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                        
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(14)
                }else if entry.isEmpty ?? false {
                    ZStack {
                        VStack(spacing: 10) {
                            Image(systemName: "moon.zzz.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.95))

                            Text("No more trains")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)

                            VStack(spacing: 4) {
                                Text(entry.fromStation)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.white.opacity(0.92))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)

                                Image(systemName: "arrow.down")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white.opacity(0.65))

                                Text(entry.toStation)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.white.opacity(0.92))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }

                            Text("Check again later")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.white.opacity(0.72))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                    }
                }else{
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .center) {
                            Text(entry.departureTime)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Spacer()
                            
                            Text(entry.platForm ?? "--")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Capsule())
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(entry.fromStation)
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.white.opacity(0.7))
                                
                                Text(entry.toStation)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.9))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                            }
                        }
                        
                        Spacer(minLength: 0)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(entry.status)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(color)
                                .lineLimit(1)
                            
                            Text("Updated \(entry.lastUpdated, style: .time)")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.62))
                                .lineLimit(1)
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
            .containerBackground(for: .widget) {
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.08, blue: 0.15),
                        Color(red: 0.08, green: 0.14, blue: 0.26),
                        Color(red: 0.10, green: 0.22, blue: 0.34)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
    
    struct TrainBoardWidget: Widget {
        let kind: String = "TrainBoardWidget"
        
        var body: some WidgetConfiguration {
            AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
                TrainBoardWidgetEntryView(entry: entry)
            }
        }
    }
    
    
    #Preview(as: .systemSmall) {
        TrainBoardWidget()
    } timeline: {
        TrainEntry(date: Date(), fromStation: "East Grinstead", toStation: "London Victoria", departureTime: "14.27", status: "On time",platForm: "3", lastUpdated: Date(), errorMessage: nil,isEmpty: true)
    }

