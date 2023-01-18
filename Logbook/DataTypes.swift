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
  var days: DayCollectionReference
  var memebers: [UserDocumentReference]
}

// a users profile
struct User {
  var email: String
  var isCoach: Bool
  var runs: RunCollectionReference?
  var summaries: SummaryCollectionReference?
  var daysOfInfo: DayInfoCollectionReference?
  var team: String
  var userName: String
  var uuid: String
}

// repersents the activities of a user for a given day
struct DayInfo {
  var date: UInt
  var runs: [ActivityDocumentReference]
  var sleep: Double
}

// repersents the activities of a team for a given day
struct Day {
  var date: Date
  var runs: [SummaryDocumentReference]
  var eachDayInfo: [DayInfoDocumentReference]
}

// a quick summary of a user for a given day
struct Summary {
  var runs: [RunDocumentReference]
  var sleep: Double
}

// a detailed info of a run used in posts
struct Activity {
  var author: String
  var id: String
  var run: RunDocumentReference?
  var comment: String
  var privateComment: String
  var visible: Bool
}

// a wrapper for a run
struct Run {
  var miles: Double
  var pain: Double
}













// MARK: Wraping typed document ref

struct TeamDocumentReference {
  let ref: DocumentReference
}

// a users profile
struct UserDocumentReference {
  let ref: DocumentReference
}

// repersents the activities of a user for a given day
struct DayInfoDocumentReference {
  let ref: DocumentReference
}

// repersents the activities of a team for a given day
struct DayDocumentReference {
  let ref: DocumentReference
}

// a quick summary of a user for a given day
struct SummaryDocumentReference {
  let ref: DocumentReference
}

// a detailed info of a run used in posts
struct ActivityDocumentReference {
  let ref: DocumentReference
}

// a wrapper for a run
struct RunDocumentReference {
  let ref: DocumentReference
}











// MARK: Wrapped typed collection ref

struct TeamCollectionReference {
  let ref: CollectionReference
}

// a users profile
struct UserCollectionReference {
  let ref: CollectionReference
}

// repersents the activities of a user for a given day
struct DayInfoCollectionReference {
  let ref: CollectionReference
}

// repersents the activities of a team for a given day
struct DayCollectionReference {
  let ref: CollectionReference
}

// a quick summary of a user for a given day
struct SummaryCollectionReference {
  let ref: CollectionReference
}

// a detailed info of a run used in posts
struct ActivityCollectionReference {
  let ref: CollectionReference
}

// a wrapper for a run
struct RunCollectionReference {
  let ref: CollectionReference
}
