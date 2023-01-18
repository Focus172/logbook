import FirebaseFirestore

enum DataFetchErorr: Error {
  case documentNotFoundError
  case dataNotFoundError
  case unexpectedError
}

// Fetching data
// 1) Get reference
// 2) Get Data
// 3) Cast Data
// 4) Return


class DataManager: ObservableObject {
  
  let db = Firestore.firestore()
  
  // MARK: Data Fetching
  
  /*
  func getTeam(teamName: String) -> Team {
    let selectedTeam = db.collection("Teams").document(teamName)
   // preocess into team object
  }
   */
  
  // this should really throw as this type of data should not be filled in randomly
  func getUser(uuid: String) -> User {
    // 1) getting user reference
    let selectedUser = db.collection("Users").document(uuid)
    
    // 2) Get Data
    let data = getDataFromDocumentRef(ref: selectedUser)
    
    // 3) Cast Data
    let email: String = data["email"] as? String ?? "------"
    let isCoach: Bool = data["isCoach"] as? Bool ?? false
    let name: String = data["username"] as? String ?? "-----"
    let team: String = data["teamName"] as? String ?? "-----"
    let runs: RunCollectionReference? = data["runs"] as? RunCollectionReference
    let summaries: SummaryCollectionReference? = data["summaries"] as? SummaryCollectionReference
    let daysOfInfo: DayInfoCollectionReference? = data["dayInfo"] as? DayInfoCollectionReference
    let uuid: String = data["uuid"] as? String ?? ""
    
    // 4) Return
    return User(email: email, isCoach: isCoach, runs: runs, summaries: summaries, daysOfInfo: daysOfInfo, team: team, userName: name, uuid: uuid)
  }
  
  func getDayInfo(authorUuid: String, date: Date) -> DayInfo {
    // 1) getting user reference
    let dayTimeStamp = UserHelper().getDayTimeStamp(date: date)
    
    let userDayInfoReference = db.document("UserDayInfos/\(authorUuid)/DayInfo/\(dayTimeStamp)")
    
    // 2) Get Data
    let userDayInfoData = getDataFromDocumentRef(ref: userDayInfoReference)
    
    // 3) Cast Data
    var retDate: UInt?
    var retRuns: [ActivityDocumentReference] = []
    var retSleep: Double?
    
    for item: Any in userDayInfoData {
      if let date = item as? UInt {
        retDate = date
      }
      else if let run = item as? DocumentReference {
        retRuns.append(ActivityDocumentReference(ref: run))
      }
      else if let sleep = item as? Double {
        retSleep = sleep
      }
    }
    
    // 4) Return
    return DayInfo(date: retDate ?? 0, runs: retRuns, sleep: retSleep ?? 0.0)
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
  
  /*
  func getRun() {
    
  }
  */
  
  func getUuid(email: String) -> String? {
    let db = Firestore.firestore()
    let userUuidRef = db.collection("UserUuids").document(email)
    
    let data = getDataFromDocumentRef(ref: userUuidRef)
    
    if let uuid = data["uuid"] as? String {
      return uuid
    }
    
    return nil
  }
  
  // MARK: Fetching data from known references
  
  
  func getActivitiesFromReference() -> Activity {
    
  }
  
  
  // MARK: Data Publishing
  
  func publishTeam() {
    ()
  }
  
  func publishUser(uuid: String, email: String, userName: String, isCoach: Bool, teamName: String) {
    
    // make sure there is a way to always find user quickly
    let _ = publishUuid(email: email, uuid: uuid)
    
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
    
    // TODO: add them to the team they specified
  }
  
  func publishDayInfo(authorUuid: String, dayTimeStamp: String, sleep: Double, activityReference: DocumentReference, activityTimeStamp: String) -> DocumentReference {
    let dayInfoReference = db.document("UserDayInfos/\(authorUuid)/DayInfo/\(dayTimeStamp)")
    
    dayInfoReference.setData(["sleep": sleep, activityTimeStamp: activityReference,], merge: true)
    
    return dayInfoReference
  }
  
  func publishDay() {
    ()
  }
  
  func publishSummary(uuid: String, timeStamp: String, runReference: DocumentReference) -> DocumentReference {
    let userSummary = db.document("UserSummaries/\(uuid)Summaries/Summaries/\(timeStamp)")
    
    userSummary.setData(["run\(timeStamp)": runReference], merge: true) { error in
      // do something
    }
    
    return userSummary
  }
  
  
  func publishActivity(title: String, authorUuid: String, userRunReference: DocumentReference, postComment: String, painComment: String, publiclyVisible: Bool, curTimeStamp: String) -> DocumentReference {
    
    // TODO: add cross training, add altitude, add mental feeling
    
    let userActivityReference = db.document("userActivities/\(authorUuid)/Activities/\(curTimeStamp)")
    
    userActivityReference.setData(["title": title, "author": authorUuid, "runReference": userRunReference, "postComment": postComment,"painComment": painComment , "visable": publiclyVisible]) { error in
      // do something
    }
    
    return userActivityReference
    
  }
  
  func publishRun(uuid: String, timeStamp: String, milage: Double, pain: Double) -> DocumentReference {
    
    let userRun = db.document("UserRuns/\(uuid)Runs/Runs/\(timeStamp)")
    userRun.setData(["distance": milage, "pain": pain]) { error in
      // do something
    }
    
    return userRun
  }
  
  func publishUuid(email: String, uuid: String) -> DocumentReference {

    let uuidStorageLocationReference = db.document("UserUuids/\(email)")
    uuidStorageLocationReference.setData(["uuid": uuid]) { error in
      // do something
    }
    
    return uuidStorageLocationReference
  }
  
  
  // MARK: Adding references
  
  func addSummaryToTeamSummary(uuid: String, onDay: String, team: String, summaryReference: DocumentReference) -> DocumentReference {
    
    let teamSummaryReference = db.document("TeamSummaries/\(team)/Summaries/\(onDay)")
    
    teamSummaryReference.setData(["\(uuid)": summaryReference]) {error in //, merge: true
      // do something
    }
    
    return teamSummaryReference
  }
  
  func addTeamSummaryToDay() -> DocumentReference {
    return db.document("")
  }
  
  func addToRecentActivities(activity: DocumentReference, timeStamp: String) -> DocumentReference {
    let recentActivitiesReference = db.document("RecentActivities/\(timeStamp)")
    
    // this currently allows two activities posted at the same time to share a spot
    recentActivitiesReference.setData(["activityReference": activity], merge: true) { error in
      // do something
    }
    
    return recentActivitiesReference
  }
  
  
  
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
      
      if let _run = run {
        returnedActivities.append(Activity(author: author, id: id, run: RunDocumentReference(ref: _run), comment: postComment, privateComment: feelingComment, visible: publiclyVisible))
        
      }
    }
    
    return returnedActivities
  }
  
  
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

  // Users (UserRuns [ref], UserDayInfo [ref], data)
  // UserDayInfo (UserActivities [ref], data
  // UserActivities (Run ref, data)
  // UserRuns (data)

  // TeamRecentActivities (TeamActivityStreams [ref])
  // TeamActivityStreams(UserActivities [ref])
  // RecentActivities (ctivityStreams [ref])
  // ActivityStreams(UserActivities [ref])
  
}
