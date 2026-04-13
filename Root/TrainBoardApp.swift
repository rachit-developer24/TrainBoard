//
//  TrainBoardApp.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import SwiftUI

@main
struct TrainBoardApp: App {
    @State var ViewModel = TrainViewModel(service: FetchTrainService())
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ViewModel)
        }
    }
}
