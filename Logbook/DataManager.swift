//
//  DataManager.swift
//  Logbook
//
//  Created by Evan Stokdyk on 12/27/22.
//  Copyright © 2022 NexThings. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

/*
 things to add:
 > Option for cross training minutes
 > expiration date for users
 > 3 comment sections
 > pace
 >
 */

class DataManager: ObservableObject {
  
  // there is some optimization to spliting this into different files but that can be done when the code works
  
  @Published var team: Team?
  @Published var user: User?
  @Published var dayInfo: DayInfo?
  @Published var day: Day?
  @Published var summmary: Summary?
  @Published var activity: Activity?
  @Published var run: Run?
  
  @Published var teams: [Team]?
  @Published var users: [User]?
  @Published var dayInfos: [DayInfo]?
  @Published var days: [Day]?
  @Published var summmaries: [Summary]?
  @Published var activities: [Activity]?
  @Published var runs: [Run]?
  
  func getTeam() {
    ()
  }
  
  func getUser() {
    ()
  }
  
  func getDayInfo() {
    ()
  }
  
  func getDay() {
    ()
  }

  func getSummary() {
    ()
  }
  
  func getActivity() {
    ()
  }
  
  func getRun() {
    
  }
  
  func publishTeam() {
    ()
  }
  
  func publishUser() {
    ()
  }
  
  func publishDayInfo() {
    ()
  }
  
  func publishDay() {
    ()
  }


  func publishSummary() {
    ()
  }

  func publishActivity(date: Date, author: String, milage: Double, pain: Double, postComment: String, feelingComment: String, publiclyVisible: Bool) {
    let db = Firestore.firestore()
    let ref = db.collection("Activities").document()
    
    // adding current date to this should make it unique enough as it would require one person to make two post at once
    let id = (date.description + author.description + milage.description + pain.description + postComment + feelingComment + publiclyVisible.description + Date().description).hashValue
  
    // TODO: FIX THIS TO MATCH NEW SCHEME
  
    ref.setData(["id": id, "date": date, "author" : author, "milage" : milage, "pain" : pain, "postComment" : postComment, "feelingComment": feelingComment, "publiclyVisible": publiclyVisible]) { error in
      
      if let error = error {
        print(error.localizedDescription) //do Better
      }
    }
  }
  
  func publishRun() {
    
  }
  
  func getActivities() {
    let database = Firestore.firestore()
    let ref = database.collection("Activities")
      
    self.activities = []
    
    ref.getDocuments { snapshot, error in
      guard error == nil else {
        print(error!.localizedDescription)
        return
      }
      
      if let snapshot = snapshot {
        //var count = 0
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
          
          self.activities!.append(Activity(author: author, id: id, run: Run(miles: milage, pain: pain), comment: postComment, privateComment: feelingComment, visible: publiclyVisible))
          
          //count += 1
        }
      }
    }
  }
  
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
}
