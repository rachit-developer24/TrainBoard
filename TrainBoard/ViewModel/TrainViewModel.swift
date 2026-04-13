//
//  TrainViewModel.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import Foundation
import Observation
@Observable
class TrainViewModel{
    
    var trains:Train?
    let service:FetchTrainsProtocol
    var isloading:Bool = false
    var trainError:String?
    var stations:[Station] = mockStations
    var filteredStations = [Station]()
    
    init(service:FetchTrainsProtocol){
        self.service = service
    }
    
    func fetchTrains(crs:String)async{
        guard !crs.isEmpty else{return}
        isloading = true
        defer{
            isloading = false
        }
        do{
            self.trains = try await service.fetchTrains(crs: crs)
        }catch{
            self.trainError = error.localizedDescription
        }
    }
    
    func filterStations(input: String) {
        guard !input.isEmpty else {
            filteredStations = []
            return
        }

        let filtered = stations.filter {
            $0.stationName.localizedCaseInsensitiveContains(input) ||
            $0.crs.localizedCaseInsensitiveContains(input)
        }

        filteredStations = filtered
    }

}
