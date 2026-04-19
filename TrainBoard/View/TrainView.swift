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
    @State private var from: String = ""
    @State private var to: String = ""
    @State private var selectedFromStation: Station?
    @State private var selectedToStation: Station?
    @FocusState private var focusField:ActiveField?
    @State private var stationSearchQuery = ""
    
    @Environment(TrainViewModel.self) var viewModel
    @Environment(\.modelContext) var context
    @Query(sort: \RecentStation.searchedAt, order: .reverse) var recentStations: [RecentStation]
    
    @State var shouldDismissKeyboard: Bool = false
    @State private var activeField: ActiveField = .searchText
    @State private var activeSheet:ActiveField? = nil
    enum ActiveField:Identifiable {
        var id: Self{self}
        case searchText
        case from
        case to
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ElegantBackground()
                
                VStack(spacing: 20) {
                    topSection
                    if viewModel.arrivalandDestinationTrains == nil{
                        journeyPlannerCard
                            .transition(.opacity)
                    }
                    Spacer()
                    contentSection
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.arrivalandDestinationTrains == nil)
                .ignoresSafeArea(.keyboard,edges: .bottom)
                .padding(.top, 16)
                
                if !viewModel.filteredStations.isEmpty {
                    VStack {
                        Spacer()
                        
                        StationSuggestionsCard(
                            stations: viewModel.filteredStations,
                            onSelect: { station in
                                isSelectingSuggestion = true
                                switch activeField {
                                case .searchText:
                                    isSelectingSuggestion = true
                                    resetJourneyPlannerState()
                                    searchText = station.stationName
                                    
                                    let recent = RecentStation(
                                        stationName: station.stationName,
                                        crs: station.crs,
                                        searchedAt: Date()
                                    )
                                    
                                    if !recentStations.contains(where: { $0.stationName == recent.stationName }) {
                                        context.insert(recent)
                                    }
                                    
                                    viewModel.filteredStations = []
                                    shouldDismissKeyboard = true
                                    
                                    Task {
                                        await viewModel.fetchTrains(crs: station.crs)
                                        isSelectingSuggestion = false
                                    }
                                    
                                case .from:
                                    isSelectingSuggestion = true
                                    from = station.stationName
                                    selectedFromStation = station
                                    focusField = nil
                                    let recent = RecentStation(
                                        stationName: station.stationName,
                                        crs: station.crs,
                                        searchedAt: Date()
                                    )
                                    
                                    if !recentStations.contains(where: { $0.stationName == recent.stationName }) {
                                        context.insert(recent)
                                    }
                                    
                                    viewModel.filteredStations = []
                                    shouldDismissKeyboard = true
                                    
                                    Task {
                                        isSelectingSuggestion = false
                                    }
                                    
                                case .to:
                                    isSelectingSuggestion = true
                                    to = station.stationName
                                    selectedToStation = station
                                    focusField = nil
                                    let recent = RecentStation(
                                        stationName: station.stationName,
                                        crs: station.crs,
                                        searchedAt: Date()
                                    )
                                    
                                    if !recentStations.contains(where: { $0.stationName == recent.stationName }) {
                                        context.insert(recent)
                                    }
                                    
                                    viewModel.filteredStations = []
                                    shouldDismissKeyboard = true
                                    
                                    Task {
                                        isSelectingSuggestion = false
                                    }
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
            .overlay(alignment: .topTrailing, content: {
                if viewModel.trains != nil || viewModel.arrivalandDestinationTrains != nil{
                    Button {
                        dismissResults()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.5))
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .padding(.horizontal)
                    
                    
                }
            })
            .animation(.easeInOut(duration: 0.22), value: viewModel.filteredStations.isEmpty)
            .safeAreaInset(edge: .bottom) {
                SearchBarDock(searchText: $searchText, shouldDismissKeyboard: $shouldDismissKeyboard) {
                    Task {
                        let cleanedCode = searchText
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .uppercased()
                        
                        guard !cleanedCode.isEmpty else { return }
                        resetJourneyPlannerState()
                        viewModel.filteredStations = []
                        await viewModel.fetchTrains(crs: cleanedCode)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                .onChange(of: searchText) { _, newValue in
                    activeField = .searchText
                    if newValue.isEmpty {
                        viewModel.trains = nil
                    }
                    
                    guard !isSelectingSuggestion else { return }
                    viewModel.filterStations(input: newValue, context: .search)
                }
            }
            .sheet(item: $activeSheet) { field in
                StationPickerSheet(searchText: $stationSearchQuery, stations: viewModel.filteredStationsForPicker) { station in
                    viewModel.filteredStationsForPicker = []
                    let recent = RecentStation(stationName: station.stationName, crs: station.crs, searchedAt: Date())
                    let exists = recentStations.contains { $0.stationName == recent.stationName }
                    if !exists {
                        context.insert(recent)
                    }
                    stationSearchQuery = ""
                    activeSheet = nil
                    if field == .from {
                        from = recent.stationName
                        selectedFromStation = station
                    } else {
                        to = recent.stationName
                        selectedToStation = station
                    }
                }
                
            }
            .onChange(of: stationSearchQuery, { oldValue, newValue in
                viewModel.filterStations(input: newValue, context: .picker)
            })
            .navigationBarHidden(true)
            .simultaneousGesture(
                TapGesture().onEnded {
                    shouldDismissKeyboard = true
                    focusField = nil
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
            } else if viewModel.arrivalandDestinationTrains != nil {
                if let fromStation = selectedFromStation,
                   let toStation = selectedToStation {
                    TrainBothSideView(fromStaion: fromStation, toStation: toStation)
                }
            } else {
                PremiumIntroHeader()
            }
        }
        .padding(.horizontal, 20)
    }
    
    var journeyPlannerCard: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(.white.opacity(0.9))
                    .frame(width: 9, height: 9)
                
                Rectangle()
                    .fill(.white.opacity(0.18))
                    .frame(width: 2, height: 34)
                
                Circle()
                    .fill(.white.opacity(0.9))
                    .frame(width: 9, height: 9)
            }
            .padding(.top, 10)
            
            VStack(spacing: 10) {
                routeRow(
                    title: "From",
                    placeholder: "Departure station",
                    text: $from,
                )
                .onTapGesture {
                    activeSheet = .from
                }
                
                routeRow(
                    title: "To",
                    placeholder: "Destination station",
                    text: $to,
                )
                .onTapGesture {
                    activeSheet = .to
                }
            }
            
            Button {
                viewModel.trains = nil
                focusField = nil
                viewModel.filteredStations = []
                searchText = ""
                Task {
                    guard let fromStation = selectedFromStation,
                          let toStation = selectedToStation else { return }
                    
                    await viewModel.fetchTrainsForBothSide(
                        fromCrs: fromStation.crs,
                        toCrs: toStation.crs
                    )
                }
            } label: {
                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.black)
                    .frame(width: 42, height: 42)
                    .background(.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(selectedFromStation == nil || selectedToStation == nil)
            .opacity((selectedFromStation == nil || selectedToStation == nil) ? 0.55 : 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.16), radius: 14, x: 0, y: 8)
        .padding(.horizontal, 20)
    }
    
    func routeRow(
        title: String,
        placeholder: String,
        text: Binding<String>,
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.uppercased())
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.72))
            
            Text(text.wrappedValue.isEmpty ? placeholder:text.wrappedValue)
                .foregroundStyle(.white)
                .font(.subheadline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        }
    }
    
    var contentSection: some View {
        Group {
            if let trains = viewModel.trains {
                if let services = trains.trainServices,!services.isEmpty{
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(services, id: \.self) { service in
                                TrainDepartureCard(service: service)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                    .scrollDismissesKeyboard(.interactively)
                }else{
                    StatePanel(
                        icon: "lightrail.fill",
                        title: "No Services",
                        subtitle: "No services from \(trains.locationName) right now"
                        
                    ) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            if !recentStations.isEmpty {
                                
                                Text("Recent Searches")
                                
                                    .foregroundStyle(.white.opacity(0.7))
                                
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    LazyHStack(spacing: 12) {
                                        
                                        ForEach(recentStations) { recent in
                                            
                                            QuickCodeChip(code: recent.stationName)
                                            
                                        }
                                        
                                    }
                                    
                                    .padding(.horizontal, 2)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            } else if viewModel.arrivalandDestinationTrains != nil {
                if let trains = viewModel.arrivalandDestinationTrains {
                    if let services = trains.trainServices,!services.isEmpty{
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(services, id: \.self) { train in
                                    TrainDepartureCard(service: train)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 120)
                        }
                        .scrollDismissesKeyboard(.interactively)
                        
                    } else {
                        
                        StatePanel(
                            
                            icon: "lightrail.fill",
                            
                            title: "No Services",
                            
                            subtitle: "No services from \(selectedFromStation?.stationName ?? "") to \(selectedToStation?.stationName ?? "")  right now",
                            
                            
                        ) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                if !recentStations.isEmpty {
                                    
                                    Text("Recent Searches")
                                    
                                        .foregroundStyle(.white.opacity(0.7))
                                    
                                    
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        
                                        LazyHStack(spacing: 12) {
                                            
                                            ForEach(recentStations) { recent in
                                                
                                                QuickCodeChip(code: recent.stationName)
                                                
                                            }
                                            
                                        }
                                        
                                        .padding(.horizontal, 2)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
                }
                
                Spacer()
                
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
            } else {
                Spacer()
                
                StatePanel(
                    icon: "magnifyingglass",
                    title: "Search departures",
                    subtitle: "Enter a UK station code to view live train times"
                    
                ) {
                    VStack{
                        Text("Recent Searches")
                            .fontWeight(.semibold)
                            .font(.title3)
                        ScrollView(.horizontal){
                            
                            LazyHStack(spacing: 8) {
                                ForEach(recentStations) { recentStation in
                                    QuickCodeChip(code: recentStation.stationName)
                                        .onTapGesture {
                                            searchText = recentStation.stationName
                                            isSelectingSuggestion = true
                                            Task {
                                                await viewModel.fetchTrains(crs: recentStation.crs)
                                                isSelectingSuggestion = false
                                            }
                                            
                                        }
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                }
                
                Spacer()
            }
        }
    }
    private func dismissResults(){
        resetJourneyPlannerState()
        viewModel.trains = nil
        searchText = ""
    }
    
    private func resetJourneyPlannerState() {
        from = ""
        to = ""
        selectedFromStation = nil
        selectedToStation = nil
        viewModel.arrivalandDestinationTrains = nil
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
