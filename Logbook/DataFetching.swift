//
//  File.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/23/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DataFetching {
  
  let db = Firestore.firestore()
  
  /*
   @Dev creates team object without any call to data base
   does not require that the passed team is valid in any way
   @Param teamName the team name
   */
  func getTeam(teamName: String) -> Team {
    // could check that passed team exists
    let days = db.collection("TeamDays/\(teamName)/Days")
    let users = db.collection("TeamUsers/\(teamName)/Users")
    
    return Team(name: teamName, days: days, memebers: users)
  }
  
  // this should really throw as this type of data should not be filled in randomly
  func getUser(uuid: String) -> Result<User, Error>? {
    // 1) getting user reference
    let selectedUser = db.collection("Users").document(uuid)
    
    // 2) Get Data
    let res = getDataFromDocumentRef(ref: selectedUser)
    
    let data : Dictionary<String, Any>?
    do {
      data = try res.get()
    } catch {
      return .failure(DataFetchErorr.dataNotFoundError)
    }
    
    // 3) Cast Data
    if let email: String = data!["email"] as? String {
      if let isCoach = data!["isCoach"] as? Bool {
        if let name = data!["username"] as? String {
          if let uuid = data!["uuid"] as? String {
            let team: String = data!["teamName"] as? String ?? "no team"
            let runs: CollectionReference? = data!["runs"] as? CollectionReference
            let summaries: CollectionReference? = data!["summaries"] as? CollectionReference
            let daysOfInfo: CollectionReference? = data!["dayInfo"] as? CollectionReference
            
            // 4) Return
            return .success(User(email: email, isCoach: isCoach, runs: runs, summaries: summaries, daysOfInfo: daysOfInfo, team: team, userName: name, uuid: uuid))
          }
        }
      }
    }
    
    return .failure(DataFetchErorr.dataNotFoundError)
  }
  
  func getDayInfo(authorUuid: String, date: Date) -> Result<DayInfo, DataFetchErorr> {
    // 1) getting user reference
    let dayTimeStamp = UserHelper().getDayTimeStamp(date: date)
    
    let userDayInfoReference = db.document("UserDayInfos/\(authorUuid)/DayInfo/\(dayTimeStamp)")
    
    // 2) Get Data
    
    let res = getDataFromDocumentRef(ref: userDayInfoReference)
    let data : Dictionary<String, Any>?
    do {
      data = try res.get()
    } catch {
      return .failure(DataFetchErorr.dataNotFoundError)
    }
    
    // 3) Cast Data
    var retDate: UInt?
    var retRuns: [DocumentReference] = []
    var retSleep: Double?
    
    for item: Any in data! {
      if let date = item as? UInt {
        retDate = date
      }
      else if let run = item as? DocumentReference {
        retRuns.append(run)
      }
      else if let sleep = item as? Double {
        retSleep = sleep
      }
    }
    
    // 4) Return
    return .success(DayInfo(date: retDate ?? 0, runs: retRuns, sleep: retSleep ?? 0.0))
  }
  
  func getDay() {
    ()
  }
  
  func getSummary() {
    ()
  }
  
  func getActivity() {
    ()
  }
  
  /*
   func getRun() {
   
   }
   */
  
  func getUuid(email: String) -> Result<String, DataFetchErorr> {
    let db = Firestore.firestore()
    let userUuidRef = db.collection("UserUuids").document(email)
    
    let res = getDataFromDocumentRef(ref: userUuidRef)
    let data : Dictionary<String, Any>?
    do {
      data = try res.get()
    } catch {
      return .failure(DataFetchErorr.dataNotFoundError)
    }
    
    if let uuid = data!["uuid"] as? String {
      return .success(uuid)
    }
    
    return .failure(DataFetchErorr.dataNotFoundError)
  }
}
