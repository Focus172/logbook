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

// RecentActivity
// UserActivity
// Team
// TeamDays
// Users
// UserRuns
// UserSummary
// TeamRuns
// UserDays


// when a user pushes submit this is the process
// create a run object and send it to userRuns, id is unix time of when it is
// append it to their summary object creating it if needed
// create an activity with the run and add it to UserActivities
// > add a refence in the recentActivities, very important to stamp this

// > add reference to TeamSummary of the summary
// > add the activity to the UserDayInfo
// > > add the dayInfo to the TeamDay
// > > > add the day to the team
// > > add the dayInfo to the UserDay


// Collections:

// Teams (TeamDays [ref], data)
// TeamDays (TeamSummaries [ref], TeamDayInfo [ref], data)
// TeamSummaries (UserRuns [ref])
// TeamDayInfo (UserDayInfo [ref])

// Users (UserRuns [ref], UserDayInfo [ref], data)
// UserDayInfo (UserActivities [ref], data
// UserActivities (Run ref, data)
// UserRuns (data)

// TeamRecentActivities (TeamActivityStreams [ref])
// TeamActivityStreams(UserActivities [ref])
// RecentActivities (ctivityStreams [ref])
// ActivityStreams(UserActivities [ref])



// ALL POSTS SHOULD HAVE UNIX TIME STAMPED AS THEIR ID SO THE LIMIT-TO CAN GRAB THE MOST RECENT


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
  
  func getUser(email: String) {
    let db = Firestore.firestore()
    let selectedUser = db.collection("Users").document(email)
    
    selectedUser.getDocument { snapshot, error in
      guard error == nil else {
        print(error!.localizedDescription)
        return
      }
      
      if let document = snapshot {
        let data = document.data()
        let userName = data?["userName"] as? String ?? ""
        let isCoach = data?["isCoach"] as? Bool ?? false
        self.user = User(userName: userName, daysOfInfo: [], isCoach: isCoach)
      }
    }
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
  
  func publishUser(email: String, userName: String, isCoach: Bool, teamName: String) {
    
    //TODO: take a team as input and add them to the list
    
    let db = Firestore.firestore()
    let userToAdd = db.collection("Users").document(email)
    let userRuns = db.collection("UsersRuns").document(userName+"Runs").collection("Runs")
  
    //TODO: try to not be cringe
    userToAdd.setData(["userName": userName, "isCoach": isCoach, "runs": userRuns, "team": teamName]) { error in
      if let error = error {
        print(error.localizedDescription)
      }
    }
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

  func publishActivity(title: String, date: Date, author: String, milage: Double, pain: Double, postComment: String, feelingComment: String, publiclyVisible: Bool) {
    
    // when a user pushes submit this is the process
    // create a run object and send it to userRuns, id is unix time of when it is
    // append it to their summary object creating it if needed
    // create an activity with the run and add it to UserActivities
    // > add a refence in the recentActivities, very important to stamp this

    // > add reference to TeamSummary of the summary
    // > add the activity to the UserDayInfo
    // > > add the dayInfo to the TeamDay
    // > > > add the day to the team
    // > > add the dayInfo to the UserDay
    
    
    // the database reference
    let db = Firestore.firestore()
    
    // adding the run
    let timeStamp = Date().timeIntervalSince1970.description
    let userRun = db.collection("UserRuns").document("\(author)Runs").collection("Runs").document(timeStamp)
    userRun.setData(["distance": milage, "pain": pain]) {error in
      // do something
    }
    
    // taken from https://stackoverflow.com/questions/50012956/firestore-how-to-store-reference-to-document-how-to-retrieve-it
    // blame them if the bellow code breaks
    
    // create/append the run to summary object
    let userRunDocumentPointer: DocumentReference = db.document("UserRuns/\(author)Runs/Runs/\(userRun)")
    let userSummary = db.collection("UserSummary").document("\(author)Summaries").collection("Summaries").document(timeStamp)
    // it might? be permissive to user just a number not the timestamp
    userSummary.setData(["run\(timeStamp)": userRunDocumentPointer], merge: true) { error in
      // do something
    }
    
    // create an activity with the run and add it to UserActivities
    
    
    
    // adding current date to this should make it unique enough as it would require one person to make two post at once
    let id = (date.description + author.description + milage.description + pain.description + postComment + feelingComment + publiclyVisible.description + Date().description).hashValue
    
    let ref = db.collection("asdfghj").document()
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
    let ref = database.collection("Activities").limit(to: 5)
      
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
  
  // Update one field, creating the document if it does not exist.
  //db.collection("cities").document("BJ").setData([ "capital": true ], merge: true)
  
  //washingtonRef.updateData([
  //"population": FieldValue.increment(Int64(50))])
  
  
}
