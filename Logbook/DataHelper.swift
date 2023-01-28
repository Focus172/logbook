import FirebaseFirestore

enum DataFetchErorr: Error {
  case documentNotFoundError
  case dataNotFoundError
  case unexpectedError
}

class DataHelper {
  
  let db = Firestore.firestore()
  
  // MARK: Helpers 
  
  func getDataFromDocumentRef(ref: DocumentReference, callback: @escaping (Dictionary<String, Any>?, DataFetchErorr?) -> ()) {
    
    ref.getDocument { snapshot, error in
      
      if let snap = snapshot {
        callback(snap.data(), nil)
      } else {
        callback(nil, DataFetchErorr.documentNotFoundError)
      }
      return
      
    }
  }
  
  func getDocumentsFromCollectionRef(ref: Query, completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> () ) {
    
    
    
    ref.getDocuments { snapshot, error in
      /*
      guard error == nil else {
        //error.doSomething()
        return
      }
       */
      print("2")
      
      if let snap = snapshot {
        completion(snap.documents, nil)
      } else {
        completion(nil, DataFetchErorr.documentNotFoundError)
      }
    }
  }
  
  func addSummaryToTeamSummary(uuid: String, onDay: String, team: String, summaryReference: DocumentReference) -> DocumentReference {
    
    let teamSummaryReference = db.document("TeamSummaries/\(team)/Summaries/\(onDay)")
    
    teamSummaryReference.setData(["\(uuid)": summaryReference]) {error in //, merge: true
      // do something
    }
    
    return teamSummaryReference
  }
  
  func addTeamSummaryToDay() -> DocumentReference {
    return db.document("TeamDays/thisDay")
  }
  
  func addToRecentActivities(activity: DocumentReference, timeStamp: String) {
    let recentActivitiesReference = db.document("RecentActivities/\(timeStamp)")
    
    // this currently allows two activities posted at the same time to share a spot
    recentActivitiesReference.setData(["activityReference": activity], merge: true) { error in
      // do something
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
  
  //When you delete a document that has subcollections, those subcollections are not deleted. For example, there may be a document located at coll/doc/subcoll/subdoc even though the document coll/doc no longer exists.
  
  
  
  //citiesRef.whereField("population", isGreaterThan: 100000).order(by: "population").limit(to: 2)
  
  // Update one field, creating the document if it does not exist.
  //db.collection("cities").document("BJ").setData([ "capital": true ], merge: true)
  
  //washingtonRef.updateData(["population": FieldValue.increment(Int64(50))])
  
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
  // TeamRuns
  // Users
  // UserRuns
  // UserSummary
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
  // TeamMembers (Users [ref])

  // Users (UserRuns [ref], UserDayInfo [ref], data)
  // UserDayInfo (UserActivities [ref], data
  // UserActivities (Run ref, data)
  // UserRuns (data)

  // TeamRecentActivities (TeamActivityStreams [ref])
  // TeamActivityStreams(UserActivities [ref])
  // RecentActivities (ctivityStreams [ref])
  // ActivityStreams(UserActivities [ref])
  
}
