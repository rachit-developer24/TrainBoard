//
//  TrainServices.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import Foundation
struct TrainServices:Codable,Hashable{
    var std :String
    var etd :String?
    var platform :String?
    var trainOperator:String
    var isCancelled:Bool?
    var origin:[TrainLocation]
    var destination:[TrainLocation]
    
      enum CodingKeys: String, CodingKey{
          case std
          case etd
          case platform
          case trainOperator = "operator"
          case isCancelled
          case origin
          case destination
      }
}
