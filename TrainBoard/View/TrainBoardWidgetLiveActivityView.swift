//
//  TrainBoardWidgetLiveActivityView.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 24/04/2026.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct TrainBoardWidgetLiveActivityView: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrainActivityAttributes.self) { context in
            
            let statusColor: Color = {
            if context.state.isCancelled { return .red }
            if context.state.expectedDepartureDate.timeIntervalSince(context.attributes.std) > 60
                   || context.state.status.lowercased().contains("delayed") {
                    return .orange
                }
                return .green
            }()
            ZStack {
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.01, green: 0.06, blue: 0.05),
                        Color(red: 0.01, green: 0.13, blue: 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 14) {
                    
                    HStack(alignment: .top, spacing: 14) {
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("FROM")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.42))
                                .tracking(0.8)
                            
                            Text(context.attributes.fromStation)
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.72)
                            
                            Text(context.attributes.std, style: .time)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.48))
                                .monospacedDigit()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 8) {
                            HStack(spacing: 7) {
                                Circle()
                                    .fill(statusColor)
                                    .frame(width: 9, height: 9)
                                
                                Text(context.state.isCancelled ? "Cancelled" : context.state.status)
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(statusColor)
                                    .lineLimit(1)
                            }
                            .padding(.top, 24)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("TO")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.42))
                                .tracking(0.8)
                            
                            Text(context.attributes.toStation)
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.72)
                            
                            Text("Platform \(context.state.platform ?? "TBC")")
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .foregroundStyle(statusColor)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(context.state.isCancelled ? "SERVICE" : "DEPARTS IN")
                                .font(.caption)
                                .fontWeight(.heavy)
                                .foregroundStyle(.white.opacity(0.45))
                                .tracking(0.5)
                            
                            if context.state.isCancelled {
                                Text("Cancelled")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.red)
                            } else {
                                Text(context.state.expectedDepartureDate, style: .timer)
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(statusColor)
                                    .monospacedDigit()
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: context.state.isCancelled ? "xmark.octagon.fill" : "tram.fill")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(statusColor)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 24)
                .padding(.bottom, 20)
            }
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(statusColor)
            
        } dynamicIsland: { context in
            
            let statusColor: Color = {
                if context.state.isCancelled { return .red }
                if context.state.expectedDepartureDate.timeIntervalSince(context.attributes.std) > 60
                   || context.state.status.lowercased().contains("delayed") {
                    return .orange
                }
                return .green
            }()
            return DynamicIsland {
                
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("FROM")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal,8)
                        Text(context.attributes.fromStation)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        
                        Text(context.attributes.std, style: .time)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("TO")
                            .padding(.horizontal,8)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        
                        Text(context.attributes.toStation)
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        
                        Text("Platform \(context.state.platform ?? "TBC")")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(statusColor)
                    }
                    
                }
                
                DynamicIslandExpandedRegion(.center) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 8, height: 8)
                        
                        Text(context.state.isCancelled ? "Service cancelled" : context.state.status)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(statusColor)
                            .lineLimit(1)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(context.state.isCancelled ? "SERVICE" : "DEPARTS IN")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                            
                            if context.state.isCancelled {
                                Text("Cancelled")
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.red)
                            } else {
                                Text(context.state.expectedDepartureDate, style: .timer)
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(statusColor)
                                    .monospacedDigit()
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: context.state.isCancelled ? "xmark.octagon.fill" : "tram.fill")
                            .font(.title2)
                            .foregroundStyle(statusColor)
                    }
                }
                
            } compactLeading: {
                Image(systemName: context.state.isCancelled ? "xmark.octagon.fill" : "tram.fill")
                    .foregroundStyle(statusColor)
                
            } compactTrailing: {
                if context.state.isCancelled {
                    Text("CAN")
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundStyle(.red)
                } else {
                    Text(context.state.expectedDepartureDate, style: .timer)
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundStyle(statusColor)
                        .monospacedDigit()
                }
                
            } minimal: {
                Image(systemName: context.state.isCancelled ? "xmark.octagon.fill" : "tram.fill")
                    .foregroundStyle(statusColor)
            }
        }
    }
}
#Preview("Live Activity - Lock Screen", as: .content, using: TrainActivityAttributes(
    serviceID: "1A23",
    std: Date().addingTimeInterval(600),
    fromStation: "London Victoria",
    toStation: "Brighton"
)) {
    TrainBoardWidgetLiveActivityView()
} contentStates: {
    TrainActivityAttributes.ContentState(
        isCancelled: false,
        platform: "7",
        lastUpdated: Date(),
        status: "On time",
        expectedDepartureDate: Date().addingTimeInterval(600)
    )
    
    TrainActivityAttributes.ContentState(
        isCancelled: false,
        platform: "TBC",
        lastUpdated: Date(),
        status: "Delayed",
        expectedDepartureDate: Date().addingTimeInterval(1200)
    )
    
    TrainActivityAttributes.ContentState(
        isCancelled: true,
        platform: nil,
        lastUpdated: Date(),
        status: "Cancelled",
        expectedDepartureDate: Date()
    )
}

#Preview("Dynamic Island - Expanded", as: .dynamicIsland(.expanded), using: TrainActivityAttributes(
    serviceID: "1A23",
    std: Date().addingTimeInterval(600),
    fromStation: "London Victoria",
    toStation: "Brighton"
)) {
    TrainBoardWidgetLiveActivityView()
} contentStates: {
    TrainActivityAttributes.ContentState(
        isCancelled: false,
        platform: "7",
        lastUpdated: Date(),
        status: "On time",
        expectedDepartureDate: Date().addingTimeInterval(600)
    )
}

#Preview("Dynamic Island - Compact", as: .dynamicIsland(.compact), using: TrainActivityAttributes(
    serviceID: "1A23",
    std: Date().addingTimeInterval(600),
    fromStation: "London Victoria",
    toStation: "Brighton"
)) {
    TrainBoardWidgetLiveActivityView()
} contentStates: {
    TrainActivityAttributes.ContentState(
        isCancelled: false,
        platform: "7",
        lastUpdated: Date(),
        status: "On time",
        expectedDepartureDate: Date().addingTimeInterval(600)
    )
}

#Preview("Dynamic Island - Minimal", as: .dynamicIsland(.minimal), using: TrainActivityAttributes(
    serviceID: "1A23",
    std: Date().addingTimeInterval(600),
    fromStation: "London Victoria",
    toStation: "Brighton"
)) {
    TrainBoardWidgetLiveActivityView()
} contentStates: {
    TrainActivityAttributes.ContentState(
        isCancelled: false,
        platform: "7",
        lastUpdated: Date(),
        status: "On time",
        expectedDepartureDate: Date().addingTimeInterval(600)
    )
}
