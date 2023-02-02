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
  
  // @Param team the name of the new team to be created
  // @Param coach the uuid that owns this team
  // @Dev pushes data to the database
  func publishTeam(team: String, coach: String) {

    // get location for where team will be placed
    let teamToAdd = db.document("Teams/\(team)")
    
    // get reference to their memebers (stored elsewhere in the database)
    let members = db.document("TeamUsers/\(team)")
    
    // get reference to their runs (stored elsewhere in the database)
    let runs = db.document("TeamRuns/\(team)")
      
    // get reference to their days (stored elsewhere in the database)
    let days = db.document("TeamDays/\(team)")
      
    teamToAdd.setData(["name": team, "coach": coach, "members": members, "runs": runs, "days": days]) { error in
      // do something
    }
  }
  
  func publishUser(uuid: String, email: String, userName: String, isCoach: Bool, team: String) -> DocumentReference {
    
    // get location for where user will be placed
    let userToAdd: DocumentReference = db.document("Users/\(uuid)")
    
    // get reference to their runs (stored elsewhere in the database)
    let userRuns = db.document("UsersRuns/\(uuid)Runs")
  
    userToAdd.setData(["userName": userName, "email": email, "uuid": uuid, "isCoach": isCoach, "runs": userRuns, "team": team]) { error in
      // do something
    }
    
    return userToAdd
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
  
  func publishUserPreview(team: String, uuid: String, name: String, refToUser: DocumentReference) -> DocumentReference {
    let ref = db.document("TeamUsers/\(team)/Users/\(uuid)")
    
    ref.setData(["name" : name, "uuid": uuid, "ref" : refToUser])
    
    return ref
  }
  
  func publishActivity(title: String, authorUuid: String, userRunReference: DocumentReference, postComment: String, painComment: String, publiclyVisible: Bool, curTimeStamp: String) -> DocumentReference {
    
    // TODO: add cross training, add altitude, add mental feeling
    
    let userActivityReference = db.document("UserActivities/\(authorUuid)/Activities/\(curTimeStamp)")
    
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
