//
//  Train.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import Foundation

struct Train:Codable,Hashable{
    var trainServices:[TrainServices]?
    var locationName:String
    var crs:String
}
