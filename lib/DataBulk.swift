//
//  DataBulk.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/23/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DataBulk {
  
  let db = Firestore.firestore()
  
  // MARK: Bulk Data Fetches
  
  func getActivities(limitTo: Int, completion: @escaping ([Activity], [any Error]) -> ()) {

    var returnedActivities: [Activity] = []
    var returnedErrors: [DataFetchErorr] = []
    
    let db = Firestore.firestore()
    let activitiesReference = db.collection("RecentActivities").limit(to: limitTo)
    
    
    DataHelper().getDocumentsFromCollectionRef(ref: activitiesReference) { snapshot, error in
      guard error == nil else {
        print("exit")
        return
      }
      
      if let documents = snapshot {
        
        let numDocs = documents.count
        var count = 0;
        
        for document in documents {
          
          
          let data = document.data()
          
          if let activityReference = data["activityReference"] as? DocumentReference {
            DataFetching().getActivity(uuid: "", date: "", ref: activityReference) { activity, error in
              if let act = activity {
                returnedActivities.append(act)
              } else if let e = error {
                returnedErrors.append(e)
              }
              
              count += 1
              if count >= numDocs {
                completion(returnedActivities, returnedErrors)
              }
              
            }
          }
        }
      }
    }
  }
  
  func getTeamUsers(team: String, callback: @escaping ([UserPreview]?, (any Error)?)->() ) {
    
    let ref = db.collection("TeamUsers/\(team)/Users")
    
    DataHelper().getDocumentsFromCollectionRef(ref: ref) { snapshot, error in
      
      guard error == nil else {
        // do something
        print("hit error in data bulk")
        callback(nil, error)
        return
      }
      
      var retUsers: [UserPreview] = []
      
      if let snap = snapshot {
        print("snapshot exists")
        for document in snap {
          
          let data = document.data()
          
          let name = data["name"] as? String ?? "no name"
          let uuid = data["uuid"] as? String ?? "no uuid"
          let ref = data["ref"] as? DocumentReference
          
          retUsers.append(UserPreview(name: name, uuid: uuid, refToFull: ref))
          
        }
      }
      
      callback(retUsers, nil)
      
    }
  }
   
}
