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

struct SearchBarDock: View {
    @Binding var searchText: String
    @Binding var shouldDismissKeyboard:Bool
    var onSearch: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.75))

            TextField("e.g. London Bridge or LBG", text: $searchText)
                .focused($isFocused)
                .foregroundStyle(.white)
                .textInputAutocapitalization(.characters)
                .disableAutocorrection(true)
                .submitLabel(.search)
                .onSubmit(onSearch)

            Button {
                onSearch()
                self.isFocused = false
            } label: {
                Image(systemName: "arrow.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.black)
                    .frame(width: 40, height: 40)
                    .background(.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .onChange(of: shouldDismissKeyboard) { oldValue, newValue in
                if newValue{
                    isFocused = false
                    shouldDismissKeyboard = false
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
    }
}

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

struct StationSuggestionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed
                    ? Color.white.opacity(0.05)
                    : Color.clear
            )
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct StatePanel<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let content: Content

    init(icon: String, title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)

            Text(title)
                .bold()

            Text(subtitle)
                .font(.caption)
                .opacity(0.7)

            content
        }
        .foregroundStyle(.white)
    }
}

struct QuickCodeChip: View {
    let code: String
    var body: some View {
        Text(code)
            .font(.caption.bold())
            .padding(8)
            .background(Color.white.opacity(0.1))
            .clipShape(Capsule())
    }
}

#Preview {
    TrainView()
        .environment(TrainViewModel(service: FetchTrainService()))
}
