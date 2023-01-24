//
//  DataPublishing.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/23/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import FirebaseFirestore

/*
* This class is responsible for publishing data to the firestore database
* It is not responsible for any data validation or formating
* It uses the DataHelper class for basic tasks to imporve readability
*/

class DataPublishing {
  
  let db = Firestore.firestore()
  
  // MARK: Data Publishing
  
  // @Param the data for make a new team
  // @Dev pushes data to the database
  func publishTeam(team: String, coach: String, members: CollectionReference) {

    // get location for where team will be placed
    let teamToAdd: DocumentReference = db.collection("Teams").document(team)
    
    // get reference to their runs (stored elsewhere in the database)
    let teamRuns = db.document("TeamsRuns/\(team)Runs")
      
    // get reference to their days (stored elsewhere in the database)
    let teamDays = db.document("TeamsDays/\(team)Days")
      
    teamToAdd.setData(["teamName": team, "coach": coach, "members": members, "runs": teamRuns, "days": teamDays]) { error in
      if let error = error {
        print(error.localizedDescription)
      }
    }
  }
  
  func publishUser(uuid: String, email: String, userName: String, isCoach: Bool, teamName: String) {
    
    // make sure there is a way to always find user quickly
    let _ = publishUuid(email: email, uuid: uuid)
    
    // get location for where user will be placed
    let userToAdd: DocumentReference = db.document("Users/\(uuid)")
    
    // get reference to their runs (stored elsewhere in the database)
    let userRuns = db.document("UsersRuns/\(uuid)Runs")
  
    userToAdd.setData(["userName": userName, "email": email, "uuid": uuid, "isCoach": isCoach, "runs": userRuns, "team": teamName]) { error in
      if let error = error {
        print(error.localizedDescription)
      }
    }
    
    // TODO: add them to the team they specified
  }
  
  func publishDayInfo(authorUuid: String, dayTimeStamp: String, sleep: Double, activityReference: DocumentReference, activityTimeStamp: String) -> DocumentReference {
    let dayInfoReference = db.document("UserDayInfos/\(authorUuid)/DayInfo/\(dayTimeStamp)")
    
    dayInfoReference.setData(["sleep": sleep, activityTimeStamp: activityReference,], merge: true)
    
    return dayInfoReference
  }
  
  func publishDay() {
    ()
  }
  
  func publishSummary(uuid: String, timeStamp: String, runReference: DocumentReference) -> DocumentReference {
    let userSummary = db.document("UserSummaries/\(uuid)Summaries/Summaries/\(timeStamp)")
    
    userSummary.setData(["run\(timeStamp)": runReference], merge: true) { error in
      // do something
    }
    
    return userSummary
  }
  
  
  func publishActivity(title: String, authorUuid: String, userRunReference: DocumentReference, postComment: String, painComment: String, publiclyVisible: Bool, curTimeStamp: String) -> DocumentReference {
    
    // TODO: add cross training, add altitude, add mental feeling
    
    let userActivityReference = db.document("userActivities/\(authorUuid)/Activities/\(curTimeStamp)")
    
    userActivityReference.setData(["title": title, "author": authorUuid, "runReference": userRunReference, "postComment": postComment,"painComment": painComment , "visable": publiclyVisible]) { error in
      // do something
    }
    
    return userActivityReference
    
  }
  
  func publishRun(uuid: String, timeStamp: String, milage: Double, pain: Double) -> DocumentReference {
    
    let userRun = db.document("UserRuns/\(uuid)Runs/Runs/\(timeStamp)")
    userRun.setData(["distance": milage, "pain": pain]) { error in
      // do something
    }
    
    return userRun
  }
  
  func publishUuid(email: String, uuid: String) -> DocumentReference {

    let uuidStorageLocationReference = db.document("UserUuids/\(email)")
    uuidStorageLocationReference.setData(["uuid": uuid]) { error in
      // do something
    }
    
    return uuidStorageLocationReference
  }
  
}
