//
//  TrainActivityAttributes.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 24/04/2026.
//
import Foundation
import ActivityKit
struct TrainActivityAttributes:ActivityAttributes{

    let serviceID:String
    let std:Date
    let fromStation:String
    let toStation:String

    
    struct ContentState:Hashable,Codable{
        let isCancelled:Bool
        let platform:String?
        let lastUpdated:Date
        let status:String
        let expectedDepartureDate:Date
    }
}
