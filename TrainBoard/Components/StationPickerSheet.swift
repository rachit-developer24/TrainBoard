//
//  StationPickerSheet.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 17/04/2026.
//
import SwiftUI

struct StationPickerSheet: View {
    
    @Binding var searchText:String
    @Environment(\.dismiss)private var dismiss
    let stations:[Station]
    let onSelect:(Station)->Void
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                ElegantBackground()
                VStack{
                    TextField("Search a Station...", text:
                                $searchText)
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    }
                    if stations.isEmpty{
                        if searchText.isEmpty{
                            StatePanel(
                                icon: "magnifyingglass",
                                title: "Find a station",
                                subtitle: "Start typing a station name or code"
                            ){}
                        }else{
                            StatePanel(
                                icon: "questionmark.circle",
                                title: "No results",
                                subtitle: "No stations match \"\(searchText)"
                            ){}
                        }
                        
                    }else{
                        ScrollView{
                            ForEach(stations){station in
                                Button {
                                    onSelect(station)
                                } label: {
                                    StationSuggestionRow(station: station)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    Spacer()
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.app.fill")
                                .frame(width: 50, height: 50)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                        
                    }
                }
                .navigationTitle("Pick a station")
                .navigationBarTitleDisplayMode(.inline)
            }
            
        }
    }
}

#Preview {
    StationPickerSheet(searchText: .constant(""), stations: [Station(stationName: "London Victoria", crs: "VIC"),Station(stationName: "London Bridge", crs: "LBG"),Station(stationName: "Clapham Junction", crs: "CLJ")], onSelect:{_ in}  )
}
