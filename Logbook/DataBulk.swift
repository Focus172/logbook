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
  
  func getActivities(limitTo: Int) -> [Result<Activity, DataFetchErorr>] {
    
    var returnedActivities: [Result<Activity, DataFetchErorr>] = []
    
    let db = Firestore.firestore()
    let activitiesReference = db.collection("RecentActivities").limit(to: limitTo)
    
    
    let res = DataHelper().getDocumentsFromCollectionRef(ref: activitiesReference)
    
    let documents: [QueryDocumentSnapshot]? = {
      do {
        return try res.get()
      } catch {
        return nil
      }
    }();
    
    print("\(documents?.description ?? "none")")
    
    if let documents = documents {
      
      for document in documents {
        print("loop start")
        
        let data = document.data()
        
        print("data: \(data.description)")
        if let reference = data["ActivityReference"] as? DocumentReference {
          print("ref: \(reference.description)")
          returnedActivities.append(DataFetching().getActivity(uuid: "", date: "", ref: reference))
        }
      }
    } else {
      //return .failure(DataFetchErorr.documentNotFoundError)
    }
    
    
    
    
    return returnedActivities
    
  }
  
}
