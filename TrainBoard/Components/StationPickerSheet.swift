//
//  StationPickerSheet.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 17/04/2026.
//
import SwiftUI

struct StationPickerSheet: View {
    
    @Binding var searchText: String
    @Environment(\.dismiss) private var dismiss
    let stations: [Station]
    let onSelect: (Station) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                ElegantBackground()
                
                VStack(spacing: 16) {
                    
                    // Search Bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white.opacity(0.7))
                        
                        TextField("Search a station...", text: $searchText)
                            .foregroundStyle(.white)
                            .tint(.white)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.10), lineWidth: 1)
                    }
                    
                    if stations.isEmpty {
                        if searchText.isEmpty {
                            StatePanel(
                                icon: "magnifyingglass",
                                title: "Find a station",
                                subtitle: "Start typing a station name or code"
                            ) {}
                            .padding(.top, 8)
                        } else {
                            StatePanel(
                                icon: "questionmark.circle",
                                title: "No results",
                                subtitle: "No stations match \"\(searchText)\""
                            ) {}
                            .padding(.top, 8)
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 10) {
                                ForEach(stations) { station in
                                    Button {
                                        onSelect(station)
                                    } label: {
                                        StationSuggestionRow(station: station)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 4)
                            .padding(.bottom, 8)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .navigationTitle("Pick a station")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 34, height: 34)
                                .background(.ultraThinMaterial, in: Circle())
                                .overlay {
                                    Circle()
                                        .stroke(.white.opacity(0.10), lineWidth: 1)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

#Preview {
    StationPickerSheet(
        searchText: .constant(""),
        stations: [
            Station(stationName: "London Victoria", crs: "VIC"),
            Station(stationName: "London Bridge", crs: "LBG"),
            Station(stationName: "Clapham Junction", crs: "CLJ")
        ],
        onSelect: { _ in }
    )
}
