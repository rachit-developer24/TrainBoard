//
//  TrainView.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import SwiftUI
import SwiftData
struct TrainView: View {
    @State private var searchText = ""
    @State private var isSelectingSuggestion = false
    @State private var from:String = ""
    @State private var to:String = ""
    @Environment(TrainViewModel.self) var viewModel
    @Environment(\.modelContext)var context
    @Query(sort:\RecentStation.searchedAt , order: .reverse)var recentStations:[RecentStation]
     @State var shouldDismissKeyboard:Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ElegantBackground()

                VStack(spacing: 20) {
                    topSection
                    HStack{
                     TextField("from", text: $from)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            }
                        Spacer()
                     TextField("to", text: $to)
                            .foregroundStyle(.white)
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                }
                        Button {
                            Task{
                                await viewModel.fetchTrainsForBothSide(fromCrs:from , toCrs: to)
                            }
                       
                        } label: {
                            Image(systemName: "arrow.right")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.black)
                                .frame(width: 40, height: 40)
                                .background(.white)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            }
                        
                    }
                    contentSection
                }
                .padding(.top, 16)

                if !viewModel.filteredStations.isEmpty {
                    VStack {
                        Spacer()

                        StationSuggestionsCard(
                            stations: viewModel.filteredStations,
                            onSelect: { station in
                                isSelectingSuggestion = true
                                searchText = station.stationName
                                let recent = RecentStation(stationName: station.stationName, crs: station.crs, searchedAt: Date())
                               let result = recentStations.filter{$0.stationName == recent.stationName}
                                if result.isEmpty{
                                    context.insert(recent)
                                }
                                viewModel.filteredStations = []
                                shouldDismissKeyboard = true
                                Task {
                                    await viewModel.fetchTrains(crs: station.crs)
                                    isSelectingSuggestion = false
                                }
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 86)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(1)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.22), value: viewModel.filteredStations.isEmpty)
            .safeAreaInset(edge: .bottom) {
                
                SearchBarDock(searchText: $searchText,shouldDismissKeyboard:$shouldDismissKeyboard) {
                    Task {
                        let cleanedCode = searchText
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .uppercased()

                        guard !cleanedCode.isEmpty else { return }
                        viewModel.filteredStations = []
                        await viewModel.fetchTrains(crs: cleanedCode)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .onChange(of: searchText) { _, newValue in
                    if newValue.isEmpty{
                        viewModel.trains = nil
                    }
                    guard !isSelectingSuggestion else { return }
                    viewModel.filterStations(input: newValue)
                }
            }
            .navigationBarHidden(true)
            .simultaneousGesture(
                TapGesture().onEnded{
                    shouldDismissKeyboard = true
                }
            )
            
        }
    }
}

private extension TrainView {
    var topSection: some View {
        Group {
            if let trains = viewModel.trains {
                LiveBoardHeader(
                    locationName: trains.locationName,
                    crs: trains.crs
                )
            } else {
                PremiumIntroHeader()
            }
        }
        .padding(.horizontal, 20)
    }
    var contentSection: some View {
        Group {
            if let trains = viewModel.trains {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(trains.trainServices ?? [], id: \.self) { service in
                            TrainDepartureCard(service: service)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }.scrollDismissesKeyboard(.interactively)

            }else if let trains =  viewModel.arrivalandDestinationTrains {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        StationSuggestionsCard(
                            stations: viewModel.filteredStations,
                            onSelect: { station in
                                isSelectingSuggestion = true
                                searchText = station.stationName
                                let recent = RecentStation(stationName: station.stationName, crs: station.crs, searchedAt: Date())
                               let result = recentStations.filter{$0.stationName == recent.stationName}
                                if result.isEmpty{
                                    context.insert(recent)
                                }
                                viewModel.filteredStations = []
                                shouldDismissKeyboard = true
                                Task {
                                    await viewModel.fetchTrains(crs: station.crs)
                                    isSelectingSuggestion = false
                                }
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 86)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }.scrollDismissesKeyboard(.interactively)

                
            } else if viewModel.isloading {
                Spacer()

                StatePanel(
                    icon: "train.side.front.car",
                    title: "Loading departures",
                    subtitle: "Fetching real-time data"
                ) {
                    ProgressView()
                        .tint(.white)
                }

                Spacer()

            } else if let error = viewModel.trainError {
                Spacer()

                StatePanel(
                    icon: "exclamationmark.triangle.fill",
                    title: "Something went wrong",
                    subtitle: error
                ) {
                    Button("Retry") {
                        Task {
                            let cleanedCode = searchText
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .uppercased()

                            guard !cleanedCode.isEmpty else { return }
                            viewModel.filteredStations = []
                            await viewModel.fetchTrains(crs: cleanedCode)
                        }
                    }
                    .foregroundStyle(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.white)
                    .clipShape(Capsule())
                }

                Spacer()

            } else if recentStations.isEmpty {
                Spacer()

                StatePanel(
                    icon: "magnifyingglass",
                    title: "Search departures",
                    subtitle: "Enter a UK station code to view live train times"
                ) {
                    HStack(spacing: 8) {
                        QuickCodeChip(code: "LBG")
                            .onTapGesture {
                                selectQuickCode("LBG")
                            }

                        QuickCodeChip(code: "VIC")
                            .onTapGesture {
                                selectQuickCode("VIC")
                            }

                        QuickCodeChip(code: "WAT")
                            .onTapGesture {
                                selectQuickCode("WAT")
                            }
                    }
                }

                Spacer()
            }else{
                Spacer()

                StatePanel(
                    icon: "magnifyingglass",
                    title: "Search departures",
                    subtitle: "Enter a UK station code to view live train times"
                ) {
                    HStack(spacing: 8) {
                        ForEach(recentStations){recentStation in
                            QuickCodeChip(code: recentStation.stationName)
                                .onTapGesture {
                                    searchText = recentStation.stationName
                                    Task{
                                        await viewModel.fetchTrains(crs: recentStation.crs)
                                    }
                                }
                            
                            
                        }
                    }
                }

                Spacer()
            }
        }
    }

    func selectQuickCode(_ code: String) {
        isSelectingSuggestion = true
        searchText = code
        viewModel.filteredStations = []

        Task {
            await viewModel.fetchTrains(crs: code)
            isSelectingSuggestion = false
        }
    }
}

#Preview {
    TrainView()
        .environment(TrainViewModel(service: FetchTrainService()))
}
