//
//  Activity.swift
//  Logbook
//
//  Created by Evan Stokdyk on 12/27/22.
//  Copyright © 2022 NexThings. All rights reserved.
//

import FirebaseFirestore

// MARK: Base types

// the entirety of a team
struct Team {
  var name: String
  var days: CollectionReference
  var memebers: CollectionReference
}

// a users profile
struct User {
  var email: String
  var isCoach: Bool
  var runs: CollectionReference?
  var summaries: CollectionReference?
  var daysOfInfo: CollectionReference?
  var team: String
  var userName: String
  var uuid: String
}

// repersents the activities of a user for a given day
struct DayInfo {
  var date: String
  var runs: [DocumentReference]
  var sleep: Double
  var author: String
}

struct UserPreview {
  var name: String
  var uuid: String
  var refToFull: DocumentReference?
}

// a quick summary of a user for a given day
struct Summary {
  var runs: [DocumentReference]
  var sleep: Double
}

// a detailed info of a run used in posts
struct Activity: Identifiable {
  var id: Int
  var author: String
  var run: DocumentReference
  var comment: String
  var privateComment: String
  var visible: Bool
}

// a wrapper for a run
struct Run {
  var miles: Double
  var pain: Double
}
