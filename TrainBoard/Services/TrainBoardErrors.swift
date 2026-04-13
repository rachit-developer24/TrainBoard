//
//  TrainBoardErrors.swift
//  TrainBoard
//
//  Created by Rachit Sharma on 12/04/2026.
//

import Foundation

enum TrainBoardErrors:Error{
    case invalidUrl
    case invalidResponse
    case invalidStatusCode
    
    var description:String{
        switch self {
        case .invalidUrl:
            "InvalidUrl"
        case .invalidResponse:
            "invalidResponse"
        case .invalidStatusCode:
            "invalidStatusCode"
        }
    }
}
