//
//  TrainService.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import Foundation

class FetchTrainService:FetchTrainsProtocol{
    private let token: String = Bundle.main.object(forInfoDictionaryKey: "HuxleyToken") as? String ?? ""
    
    func fetchTrainsForBothSide(fromCrs: String, toCrs: String)async throws -> Train {
        let urlString = "https://huxley2.azurewebsites.net/departures/\(fromCrs)/to/\(toCrs)?accessToken=\(token)"
        guard let url = URL(string: urlString)else{throw TrainBoardErrors.invalidUrl}
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else{throw TrainBoardErrors.invalidResponse}
        guard response.statusCode == 200 else{throw TrainBoardErrors.invalidStatusCode}
        
        let train = try JSONDecoder().decode(Train.self, from: data)
        return train
    }
    
    func fetchTrains(crs: String) async throws -> Train {
        let urlString = "https://huxley2.azurewebsites.net/departures/\(crs)?accessToken=\(token)"
        guard let url = URL(string: urlString)else{throw TrainBoardErrors.invalidUrl}
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else{throw TrainBoardErrors.invalidResponse}
        guard response.statusCode == 200 else{throw TrainBoardErrors.invalidStatusCode}
        
        let train = try JSONDecoder().decode(Train.self, from: data)
        return train
        
    }
}
