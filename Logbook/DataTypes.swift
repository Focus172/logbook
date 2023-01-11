//
//  Activity.swift
//  Logbook
//
//  Created by Evan Stokdyk on 12/27/22.
//  Copyright © 2022 NexThings. All rights reserved.
//

import SwiftUI

// the entirety of a team
// teams should have an internal acsess thing to the email look up of the poeple in their team
struct Team {
  var name: String
  var days: [Day]
  var memebers: [User]
}

// a users profile
struct User {
  var userName: String
  var teamName: String
  var daysOfInfo: [DayInfo]
  var isCoach: Bool
}

// repersents the activities of a user for a given day
struct DayInfo {
  var date: Date
  var runs: [Activity]
  var sleep: Double
}

// repersents the activities of a team for a given day
struct Day {
  var date: Date
  var runs: [Summary]
  var eachDayInfo: [DayInfo]
}

// a quick summary of a user for a given day
struct Summary {
  var runs: [Run]
  var sleep: Double
}

// a detailed info of a run used in posts
struct Activity {
  var author: String
  var id: String
  var run: Run
  var comment: String
  var privateComment: String
  var visible: Bool
}

// a wrapper for a run
struct Run {
  var miles: Double
  var pain: Double
}
