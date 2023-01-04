//
//  UserHelper.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/3/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import UIKit

class UserHelper {
  
  let LOGGED_IN_KEY = "loggedIn"
  let IS_COACH_KEY = "isCoach"
  let TEAM_KEY = "team"
  let USER_NAME_KEY = "userName"
  
  //instance var
  
  func logOut(settings: UserSettings) -> Bool {
    UserDefaults.standard.set(false, forKey: self.LOGGED_IN_KEY)
    settings.loggedIn = false
    return true
  }
  
  /*
  func logIn() {
    
  }
  */
}
