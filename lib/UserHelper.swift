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
    date.timeIntervalSince1970.description
  }
  
  func getDayTimeStamp(date: Date) -> String {
    
    Calendar.current.startOfDay(for: date).description
    
    //let isoformatter = ISO8601DateFormatter.init()
    //let timeStr = isoformatter.string(from: date)
    //return isoformatter.date(from: timeStr)!.description.prefix(10).description.replacingOccurrences(of: "-", with: "")
  }
}
