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
  
  //ref = Database.database().reference()
  //self.ref.child("users").child(user.uid).setValue(["username": username])
  
  //citiesRef.order(by: "name").limit(to: 3)
  
  //let recentPostsQuery = (ref?.child("posts").queryLimited(toFirst: 100))!
  //let postsByMostPopular = ref.child("posts").queryOrdered(byChild: "metrics/views")
  
  
  //let db = Firestore.firestore()
  //let capitalCities = db.collection("cities").whereField("capital", isEqualTo: true)
  
  
  //var collection = firebase.firestore().collection('restaurants');
  //return collection.add(data);
  
  //let alovelaceDocumentRef = db.collection("users").document("alovelace")
  //let aLovelaceDocumentReference = db.document("users/alovelace")
  //a reference does not perform any network operations
  
  
  //let messageRef = db.collection("rooms").document("roomA").collection("messages").document("message1")
  
  //Notice the alternating pattern of collections and documents. Your collections and documents must always follow this pattern. You cannot reference a collection in a collection or a document in a document.
  
  //When you delete a document that has subcollections, those subcollections are not deleted. For example, there may be a document located at coll/doc/subcoll/subdoc even though the document coll/doc no longer exists.
  
  
  
  //citiesRef.whereField("population", isGreaterThan: 100000).order(by: "population").limit(to: 2)
  
  
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
                    
                    //let iterator = count
                    let id = data["id"] as? String ?? ""
                    //let date = data["date"] as? Date ?? Date()
                    let author = data["author"] as? String ?? ""
                    let milage = data["milage"] as? Double ?? 0
                    let pain = data["pain"] as? Double ?? 0
                    let postComment = data["postComment"] as? String ?? ""
                    let feelingComment = data["feelingComment"] as? String ?? ""
                    let publiclyVisible = data["publiclyVisible"] as? Bool ?? false
                    
                    self.activities.append(Activity(author: author, id: id, run: Run(miles: milage, pain: pain), comment: postComment, privateComment: feelingComment, visible: publiclyVisible))
                    
                    count += 1
                }
            }
        }
    }
    
    func addActivity(date: Date, author: String, milage: Double, pain: Double, postComment: String, feelingComment: String, publiclyVisible: Bool) {
        let db = Firestore.firestore()
        let ref = db.collection("Activities").document()
        let id = "asdfghjk" // GENERATE A REAL ID
      
      // TODO: FIX THIS TO MATCH NEW SCHEME
      
        ref.setData(["id": id, "date": date, "author" : author, "milage" : milage, "pain" : pain, "postComment" : postComment, "feelingComment": feelingComment, "publiclyVisible": publiclyVisible]) { error in
            if let error = error {
                print(error.localizedDescription) //do Better
            }
            
        }
        
    }
    
}
