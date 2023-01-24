//
//  DataFetching.swift
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
  func getUser(uuid: String) -> Result<User, Error> {
    // 1) getting user reference
    let selectedUser = db.collection("Users").document(uuid)
    
    // 2) Get Data
    let res = DataHelper().getDataFromDocumentRef(ref: selectedUser)
    
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
  
  func getDayInfo(authorUuid: String, date: UInt) -> Result<DayInfo, DataFetchErorr> {
    // 1) getting user reference
    let userDayInfoReference = db.document("UserDayInfos/\(authorUuid)/DayInfo/\(date)")
    
    // 2) Get Data
    
    let res = DataHelper().getDataFromDocumentRef(ref: userDayInfoReference)
    let data : Dictionary<String, Any>?
    do {
      data = try res.get()
    } catch {
      return .failure(DataFetchErorr.dataNotFoundError)
    }

    // 3) Cast Data
    var retRuns: [DocumentReference] = []
    var retSleep: Double?
    
    for item: Any in data! {
      if let run = item as? DocumentReference {
        retRuns.append(run)
      }
      else if let sleep = item as? Double {
        retSleep = sleep
      }
    }
    
    // 4) Return
    return .success(DayInfo(date: date, runs: retRuns, sleep: retSleep ?? 0.0))
  }
  
  // takes a time that is 12pm on the day of the run and fetches the day for a given team
  func getDay(team: String, date: Date) -> Result<Day, DataFetchErorr> {
    // 1) getting user reference    
    let teamDayReference = db.document("TeamDays/\(team)/Days/\(date)")
    
    // 2) Get Data
    
    let res = DataHelper().getDataFromDocumentRef(ref: teamDayReference)
    let data : Dictionary<String, Any>?
    do {
      data = try res.get()
    } catch {
      return .failure(DataFetchErorr.dataNotFoundError)
    }
    
    // 3) Cast Data
    var retDate: UInt?
    var retRuns: [DocumentReference] = []
    var retDayInfo: [DocumentReference] = []
    
    for item: Any in data! {
      if let date = item as? UInt {
        retDate = date
      }
      else if let run = item as? DocumentReference {
        retRuns.append(run)
      }
      //else if let
      // ret day info = something
    }
    
    // 4) Return
    return .success(Day(date: retDate ?? 0, runs: retRuns, eachDayInfo: retDayInfo))
  }
  
  func getSummary(uuid: String, date: String) -> Result<Summary, DataFetchErorr> {
    // 1) getting summary reference
    let summaryRef = db.document("UserSummaries/\(uuid)/Summaries/\(date)")

    // 2) Get Data
    let res = DataHelper().getDataFromDocumentRef(ref: summaryRef)
    let data : Dictionary<String, Any>?
    do {
      data = try res.get()
    } catch {
      return .failure(DataFetchErorr.dataNotFoundError)
    }

    // 3) Cast Data
    let retSleep: Double = data!["sleep"] as? Double ?? 0.0
    var runs: [DocumentReference] = []

    for item: Any in data! {
      if let run = item as? DocumentReference {
        runs.append(run)
      }
    }

    // 4) Return
    return .success(Summary(runs: runs, sleep: retSleep))
  }
  

  func getActivity(uuid: String, date: String) -> Result<Activity, DataFetchErorr> {
    // 1) getting activity reference
    let activityRef = db.document("UserActivities/\(uuid)/Activities/\(date)")

    // 2) Get Data
    let res = DataHelper().getDataFromDocumentRef(ref: activityRef)
    let data : Dictionary<String, Any>?
    do {
      data = try res.get()
    } catch {
      return .failure(DataFetchErorr.dataNotFoundError)
    }

    // 3) Cast Data
    let author = data!["author"] as? String ?? "no author"
    let id = data!["id"] as? String ?? "no id"
    let run = data!["run"] as? DocumentReference
    let comment = data!["comment"] as? String ?? "no comment"
    let privateComment = data!["privateComment"] as? String ?? "no private comment"
    let visible = data!["visible"] as? Bool ?? false

    // 4) Return
    return .success(Activity(author: author, id: id, run: run, comment: comment, privateComment: privateComment, visible: visible))
  }
  
  /*
  * Fetches a run for a given user at specified time
  */
  func getRun(uuid: String, date: String) -> Result<Run, DataFetchErorr> {
    // 1) getting run reference
    let runRef = db.document("UserRuns/\(uuid)/Runs/\(date)")

    // 2) Get Data
    let res = DataHelper().getDataFromDocumentRef(ref: runRef)
    let data : Dictionary<String, Any>?
    do {
      data = try res.get()
    } catch {
      return .failure(DataFetchErorr.dataNotFoundError)
    }

    // 3) Cast Data
    let miles = data!["miles"] as? Double ?? 0.0
    let pain = data!["pain"] as? Double ?? 0.0

    // 4) Return
    return .success(Run(miles: miles, pain: pain))
  }
  
  func getUuid(email: String) -> Result<String, DataFetchErorr> {
    let db = Firestore.firestore()
    let userUuidRef = db.collection("UserUuids").document(email)
    
    let res = DataHelper().getDataFromDocumentRef(ref: userUuidRef)
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
