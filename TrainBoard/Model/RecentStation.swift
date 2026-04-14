//
//  RecentStation.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 14/04/2026.
//

import Foundation
import SwiftData
@Model
class RecentStation{
    var stationName:String
    var crs:String
    var searchedAt:Date
    
    init(stationName: String, crs: String, searchedAt: Date) {
        self.stationName = stationName
        self.crs = crs
        self.searchedAt = searchedAt
    }
}
