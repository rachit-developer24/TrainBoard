//
//  FetchTrainsProtocol.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import Foundation

protocol FetchTrainsProtocol{
    func fetchTrains(crs:String)async throws -> Train
}
