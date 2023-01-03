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
  
  //instance var
  
  // this code is hella scuffed as it requires a reference to the root controller to be passed to a very dumb meathod
  // TODO: find a way to run this code without the reference to the controller
  // @param the current root controller
  func logOut(currentDelegate: SceneDelegate) -> Bool {
    UserDefaults.standard.set(false, forKey: "loggedIn")
    //self.view.window.windowScene.delegate.reloadSettings()
    currentDelegate.reloadSettings()
    return true
  }
  
  /*
  func logIn() {
    
  }
  */
}
