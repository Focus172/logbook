//
//  Activity.swift
//  Logbook
//
//  Created by Evan Stokdyk on 12/27/22.
//  Copyright © 2022 NexThings. All rights reserved.
//

import SwiftUI

struct DayInfo {
    var author: String
    var runs: [Activity]
    var sleep: Double
}


struct Activity: Identifiable {
    var iterator: Int
    var id: String
    var date: Date
    var author: String
    var milage: Double
    var pain: Double
    var postComment: String
    var feelingComment: String
    var publiclyVisible: Bool
}
