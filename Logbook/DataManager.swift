//
//  DataManager.swift
//  Logbook
//
//  Created by Evan Stokdyk on 12/27/22.
//  Copyright © 2022 NexThings. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

class DataManager: ObservableObject {
  @Published var activities: [Activity] = []
    
    /*
    init() {
        fetchActivity()
    }
     */
    
    func fetchActivity () {
      
      let database = Firestore.firestore()
      let ref = database.collection("Activities")
        
      activities.removeAll()
      
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                
                var count = 0
                for document in snapshot.documents {
                    
                    let data = document.data()
                    
                    let iterator = count
                    let id = data["id"] as? String ?? ""
                    let date = data["date"] as? Date ?? Date()
                    let author = data["author"] as? String ?? ""
                    let milage = data["milage"] as? Double ?? 0
                    let pain = data["pain"] as? Double ?? 0
                    let postComment = data["postComment"] as? String ?? ""
                    let feelingComment = data["feelingComment"] as? String ?? ""
                    let publiclyVisible = data["publiclyVisible"] as? Bool ?? false
                    
                    self.activities.append(Activity(iterator: iterator, id: id, date: date, author: author, milage: milage, pain: pain, postComment: postComment, feelingComment: feelingComment, publiclyVisible: publiclyVisible))
                    
                    count += 1
                }
            }
        }
    }
    
    func addActivity(date: Date, author: String, milage: Double, pain: Double, postComment: String, feelingComment: String, publiclyVisible: Bool) {
        let db = Firestore.firestore()
        let ref = db.collection("Activities").document()
        let id = "asdfghjk" // GENERATE A REAL ID
        ref.setData(["id": id, "date": date, "author" : author, "milage" : milage, "pain" : pain, "postComment" : postComment, "feelingComment": feelingComment, "publiclyVisible": publiclyVisible]) { error in
            if let error = error {
                print(error.localizedDescription) //do Better
            }
            
        }
        
    }
    
}
