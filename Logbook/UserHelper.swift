//
//  UserHelper.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/3/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserHelper {
  
  func logIn(settings: UserSettings) {
    UserDefaults.standard.set(true, forKey: Strings.LOGGED_IN_KEY)
    settings.loggedIn = true
  }
  
  func logOut(settings: UserSettings) {
    UserDefaults.standard.set(false, forKey: Strings.LOGGED_IN_KEY)
    settings.loggedIn = false
  }
  
  func getCurTimeStamp(date: Date) -> String {
    UInt(date.timeIntervalSince1970).description
  }
  
  func getDayTimeStamp(date: Date) -> String {
    let isoformatter = ISO8601DateFormatter.init()
    let timeStr = isoformatter.string(from: date)
    return isoformatter.date(from: timeStr)!.description.prefix(10).description.replacingOccurrences(of: "-", with: "")
  }
  
  func publishAndUpdateActivity(authorUuid: String, title: String, milage: Double, pain: Double, postComment: String, painComment: String, date: Date, team: String, publiclyVisible: Bool) {
    
    let db = Firestore.firestore()
    let dm = DataManager()
    
    // getting the times
    let curTimeStamp = getCurTimeStamp(date: date)
    let dayTimeStamp = getDayTimeStamp(date: date)
    
    // creating the run in userRuns
    let userRunReference = dm.publishRun(uuid: authorUuid, timeStamp: curTimeStamp, milage: milage, pain: pain)
    
    // creating the summary in userSummaries
    let userSummaryReference = dm.publishSummary(uuid: authorUuid, timeStamp: dayTimeStamp, runReference: userRunReference)
    
    // -- adding the summaryReference to teamSummaries
    let teamSummaryReference = dm.addSummaryToTeamSummary(uuid: authorUuid, onDay: dayTimeStamp, team: team, summaryReference: userSummaryReference)
    
    // -- adding the teamSummariesReference to teamDays - this can be done better by instead fetch once at dawn
    let teamDayReference = dm.addTeamSummaryToDay()
    
    // creating the acticity in userActivities
    let userActivityReference = dm.publishActivity(title: title, authorUuid: authorUuid, userRunReference: userRunReference, postComment: postComment, painComment: painComment, publiclyVisible: publiclyVisible, curTimeStamp: curTimeStamp)
    
    // adding the activityReference to recentActivities
    // use the cur timestamp
    if (publiclyVisible) {
      //let _ = dm.addToRecentActivities(userActivityReference)
    }
    
    // creating the userDay in userDayInfo
    // using activityreference (appending)
    let userDayInfoReference = dm.publishDayInfo(authorUuid: authorUuid, dayTimeStamp: dayTimeStamp, sleep: 0.0, activityReference: userActivityReference, activityTimeStamp: curTimeStamp)
    
    // adding the userDayReference to teamDay
    
    
    // adding the teamDayReference to the team
    
    
    // add the dayInfoReference to Day
    

  }
}
