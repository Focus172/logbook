//
//  DataTypeFromData.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/30/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DataTypeFromData {
  
  func parseUserFromData(data: Dictionary<String, Any>) -> User? {
    // 3) Cast Data
    if let email: String = data["email"] as? String {
      if let isCoach = data["isCoach"] as? Bool {
        if let name = data["username"] as? String {
          if let uuid = data["uuid"] as? String {
            let team: String = data["teamName"] as? String ?? "no team"
            let runs: CollectionReference? = data["runs"] as? CollectionReference
            let summaries: CollectionReference? = data["summaries"] as? CollectionReference
            let daysOfInfo: CollectionReference? = data["dayInfo"] as? CollectionReference
            
            // 4) Return
            return User(email: email, isCoach: isCoach, runs: runs, summaries: summaries, daysOfInfo: daysOfInfo, team: team, userName: name, uuid: uuid)
          }
        }
      }
    }
    return nil
  }
}
