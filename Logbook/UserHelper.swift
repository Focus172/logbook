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
  
  func logIn(settings: UserSettings) {
    UserDefaults.standard.set(true, forKey: Strings.LOGGED_IN_KEY)
    settings.loggedIn = true
  }
  
  func logOut(settings: UserSettings) {
    UserDefaults.standard.set(false, forKey: Strings.LOGGED_IN_KEY)
    settings.loggedIn = false
  }
  
}
