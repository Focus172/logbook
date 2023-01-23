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
  
  func getActivities(limitTo: Int) -> [Activity] {
        
    var returnedActivities: [Activity] = []
    
    let db = Firestore.firestore()
    let activitiesReference = db.collection("Activities").limit(to: limitTo)
      
    let documents = getDocumentsFromCollectionRef(ref: activitiesReference)
        
    for document in documents {
      let data = document.data()
      
      // TODO: unwrap data in better way
      let id = data["id"] as? String ?? ""
      //let date = data["date"] as? Date ?? Date()
      let author = data["author"] as? String ?? ""
      let run = data["run"] as? DocumentReference
      let postComment = data["postComment"] as? String ?? ""
      let feelingComment = data["feelingComment"] as? String ?? ""
      let publiclyVisible = data["publiclyVisible"] as? Bool ?? false
      
      returnedActivities.append(Activity(author: author, id: id, run: run, comment: postComment, privateComment: feelingComment, visible: publiclyVisible))
    }
    
    return returnedActivities
  }
  
}
