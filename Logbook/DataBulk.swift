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
  
  func getActivities(limitTo: Int, completion: ([Activity], [any Error]) -> ()) -> () {
    
    print("1")
    
    var returnedActivities: [Activity] = []
    var returnedErrors: [any Error] = []
    
    let db = Firestore.firestore()
    let activitiesReference = db.collection("RecentActivities").limit(to: limitTo)
    
    print("2")
    
    var snap: [QueryDocumentSnapshot]?
    DataHelper().getDocumentsFromCollectionRef(ref: activitiesReference, completion: { snapshot, error in
      guard error == nil else {
        print("exit")
        return
      }
      
      print("3")
      
      snap = snapshot
    })
    
    print("4")
    
    if let documents = snap {
      print("\(documents)")
      for document in documents {
        
        let data = document.data()
        
        if let activityReference = data["ActivityReference"] as? DocumentReference {
          print("unwrapped")
          let wrappedActivity = DataFetching().getActivity(uuid: "", date: "", ref: activityReference)
          do {
            let act = try wrappedActivity.get()
            returnedActivities.append(act)
          } catch {
            returnedErrors.append(error)
          }
          
        }
      }
    }
    
    completion(returnedActivities, returnedErrors)
    
  }
}
