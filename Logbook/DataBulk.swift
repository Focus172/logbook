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
        print("\(documents)")
        
        for document in documents {
          
          let data = document.data()
          
          if let activityReference = data["ActivityReference"] as? DocumentReference {
            print("unwrapped")
            DataFetching().getActivity(uuid: "", date: "", ref: activityReference) { activity, error in
              if let act = activity {
                returnedActivities.append(act)
              } else if let e = error {
                returnedErrors.append(e)
              }
            }
          }
        }
      }
      
      completion(returnedActivities, returnedErrors)
    }
    
    
    
  }
}
