//
//  TrainService.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import Foundation

class FetchTrainService:FetchTrainsProtocol{
    func fetchTrains(crs: String) async throws -> Train {
       let urlString = "https://huxley2.azurewebsites.net/departures/\(crs)?accessToken=d675d7dd-1379-4ef4-8c2b-90b917324ace"
        guard let url = URL(string: urlString)else{throw TrainBoardErrors.invalidUrl}
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else{throw TrainBoardErrors.invalidResponse}
        guard response.statusCode == 200 else{throw TrainBoardErrors.invalidStatusCode}
        
        let train = try JSONDecoder().decode(Train.self, from: data)
        return train

    }
    
    
}
