//
//  TrainBoardWidgetBundle.swift
//  TrainBoardWidget
//
//  Created by Rachit Sharma on 20/04/2026.
//

import WidgetKit
import SwiftUI

@main
struct TrainBoardWidgetBundle: WidgetBundle {
    var body: some Widget {
        TrainBoardWidget()
        TrainBoardWidgetControl()
        TrainBoardWidgetLiveActivity()
    }
}
