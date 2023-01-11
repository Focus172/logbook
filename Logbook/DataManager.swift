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

enum DataFetchErorr: Error {
  case documentNotFoundError
  case dataNotFoundError
  case unexpectedError
}


class DataManager: ObservableObject {
  
  // Coach snapshot listener
  /*
  db.collection("cities").whereField("state", isEqualTo: "CA")
      .addSnapshotListener { querySnapshot, error in
          guard let documents = querySnapshot?.documents else {
              print("Error fetching documents: \(error!)")
              return
          }
          let cities = documents.map { $0["name"]! }
          print("Current cities in CA: \(cities)")
      }
   */
  
  
  // MARK: Data Fetching
  
  func getTeam() {
    ()
  }
  
  // this should really throw as this type of data should not be filled in randomly
  func getUser(uuid: String) -> User {
    let db = Firestore.firestore()
    let selectedUser = db.collection("Users").document(uuid)
    
    let data = getDataFromDocumentRef(ref: selectedUser)
    
    // TODO: handle this data better
    let username = data["username"] as? String ?? ""
    let teamName = data["teamName"] as? String ?? ""
    //let email = data["email"] as? String ?? ""
    let isCoach = data["isCoach"] as? Bool ?? false
    
    return User(userName: username, teamName: teamName, daysOfInfo: [], isCoach: isCoach)
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
  
  func getUuid(email: String) -> String? {
    let db = Firestore.firestore()
    let userUuidRef = db.collection("UserUuids").document(email)
    
    let data = getDataFromDocumentRef(ref: userUuidRef)
    
    if let uuid = data["uuid"] as? String {
      return uuid
    }
    
    return nil
  }
  
  // MARK: Data Publishing
  
  func publishTeam() {
    ()
  }
  
  func publishUser(uuid: String, email: String, userName: String, isCoach: Bool, teamName: String) {
    
    // make sure there is a way to always find user quickly
    publishUuid(email: email, uuid: uuid)
    
    // get location for where user will be placed
    let db = Firestore.firestore()
    let userToAdd: DocumentReference = db.collection("Users").document(uuid)
    
    // get reference to their runs (stored elsewhere in the database)
    let userRuns = db.document("UsersRuns/\(uuid)Runs")
  
    userToAdd.setData(["userName": userName, "email": email, "uuid": uuid, "isCoach": isCoach, "runs": userRuns, "team": teamName]) { error in
      if let error = error {
        print(error.localizedDescription)
      }
    }
    
    // TODO: add them to the team the specified
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

  func publishActivity(title: String, date: Date, uuid: String, milage: Double, pain: Double, postComment: String, feelingComment: String, publiclyVisible: Bool) {
    
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
    
    

    let db = Firestore.firestore()

    // the way the run will be referenced
    let curTimeStamp = UInt(Date().timeIntervalSince1970).description
    
    //let isoformatter = ISO8601DateFormatter.init()
    //let timeStr = isoformatter.string(from: date)
    //let _ = isoformatter.date(from: timeStr).prefix(10).description // gets the date as YYYY-MM-DD
    
    let dayTimeStamp = UInt(date.timeIntervalSince1970).description
    
    
    // adding the run
    let userRun = db.document("UserRuns/\(uuid)Runs/Runs/\(curTimeStamp)")
    userRun.setData(["distance": milage, "pain": pain]) {error in
      // do something
    }
    
    let userSummary = db.document("UserSummaries/\(uuid)Summaries/Summaries/\(dayTimeStamp)")
    
    userSummary.setData(["run\(curTimeStamp)": userRun], merge: true) { error in
      // do something
    }
    
    // create an activity with the run and add it to UserActivities
    
    /*
    
    // adding current date to this should make it unique enough as it would require one person to make two post at once
    let id = (date.description + author.description + milage.description + pain.description + postComment + feelingComment + publiclyVisible.description + Date().description).hashValue
    
    let ref = db.collection("asdfghj").document()
    ref.setData(["id": id, "date": date, "author" : author, "milage" : milage, "pain" : pain, "postComment" : postComment, "feelingComment": feelingComment, "publiclyVisible": publiclyVisible]) { error in
      
      if let error = error {
        print(error.localizedDescription) //do Better
      }
    }
     */
  }
  
  func publishRun() {
    
  }
  
  func publishUuid(email: String, uuid: String) {
    // get the location of the uuidStorage
    let db = Firestore.firestore()
    let uuidStorageLocationReference = db.collection("UserUuids").document(email)
    
    // push new data to that storage
    uuidStorageLocationReference.setData(["uuid": uuid])
  }
  
  // MARK: Bulk Data Fetches
  
  func getActivities() -> [Activity] {
        
    var returnedActivities: [Activity] = []
    
    let db = Firestore.firestore()
    let activitiesReference = db.collection("Activities").limit(to: 5)
      
    let documents = getDocumentsFromCollectionRef(ref: activitiesReference)
        
    for document in documents {
      let data = document.data()
      
      // TODO: unwrap data in better way
      let id = data["id"] as? String ?? ""
      //let date = data["date"] as? Date ?? Date()
      let author = data["author"] as? String ?? ""
      let milage = data["milage"] as? Double ?? 0
      let pain = data["pain"] as? Double ?? 0
      let postComment = data["postComment"] as? String ?? ""
      let feelingComment = data["feelingComment"] as? String ?? ""
      let publiclyVisible = data["publiclyVisible"] as? Bool ?? false
      
      returnedActivities.append(Activity(author: author, id: id, run: Run(miles: milage, pain: pain), comment: postComment, privateComment: feelingComment, visible: publiclyVisible))
    }
    
    return returnedActivities
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
  
  //When you delete a document that has subcollections, those subcollections are not deleted. For example, there may be a document located at coll/doc/subcoll/subdoc even though the document coll/doc no longer exists.
  
  
  
  //citiesRef.whereField("population", isGreaterThan: 100000).order(by: "population").limit(to: 2)
  
  // Update one field, creating the document if it does not exist.
  //db.collection("cities").document("BJ").setData([ "capital": true ], merge: true)
  
  //washingtonRef.updateData([
  //"population": FieldValue.increment(Int64(50))])
  
  func getDataFromDocumentRef(ref: DocumentReference) -> Dictionary<String, Any> {
    var retData: Dictionary<String, Any> = [:]
    
    ref.getDocument { snapshot, error in
      guard error == nil else {
        print(error!.localizedDescription)
        return
      }
      
      // lots of data unwrapping beacuse we live in a fairy tale
      if let document = snapshot {
        if let data = document.data() {
          retData = data
        }
      }
    }
    
    return retData
  }
  
  func getDocumentsFromCollectionRef(ref: Query) -> [QueryDocumentSnapshot] {
    var retDocuments: [QueryDocumentSnapshot] = []
    
    ref.getDocuments { snapshot, error in
      guard error == nil else {
        print(error!.localizedDescription)
        return
      }
      
      if let snap = snapshot {
        retDocuments = snap.documents
      }
    }
    
    return retDocuments
  }
  
}
