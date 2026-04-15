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
    var arrivalandDestinationTrains:Train?
    
    let service:FetchTrainsProtocol
    var isloading:Bool = false
    var trainError:String?
    var stations:[Station] = mockStations
    var filteredStations = [Station]()
    
    var fromCrs = ""
    var toCrs = ""
    
    
    init(service:FetchTrainsProtocol){
        self.service = service
    }
    
    func fetchTrainsForBothSide(fromCrs:String,toCrs:String)async{
        guard !fromCrs.isEmpty else{return}
        guard !toCrs.isEmpty else{return}
        isloading = true
        defer{
            isloading = false
        }
        do{
            self.arrivalandDestinationTrains = try await service.fetchTrainsForBothSide(fromCrs: fromCrs, toCrs: toCrs)
        }catch{
            self.trainError = error.localizedDescription
        }
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
