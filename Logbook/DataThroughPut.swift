import FirebaseFirestore

class DataThroughPut {

  func publishUserWithTeamControl(uuid: String, email: String, name: String, isCoach: Bool, team: String) {
    let dp = DataPublishing()
    
    let _ = dp.publishUuid(email: email, uuid: uuid)
    
    let user = dp.publishUser(uuid: uuid, email: email, userName: name, isCoach: isCoach, team: team)
    
    let _ = dp.publishUserPreview(team: team, uuid: uuid, name: name, refToUser: user)
    
    if isCoach {
      dp.publishTeam(team: "team", coach: uuid)
    } else {
      Firestore.firestore().collection("TeamUsers/\(team)/Users")
        .addDocument(data: ["user": user])
    }
  }
  
  
    func publishAndUpdateActivity(authorUuid: String, title: String, milage: Double, pain: Double, postComment: String, painComment: String, date: Date, team: String, publiclyVisible: Bool, curTimeStamp: String, dayTimeStamp: String) {
    
        let dp = DataPublishing()
        let dh = DataHelper()
        
        // creating the run in userRuns
        let userRunReference = dp.publishRun(uuid: authorUuid, timeStamp: curTimeStamp, milage: milage, pain: pain)
    
        // creating the summary in userSummaries
        let userSummaryReference = dp.publishSummary(uuid: authorUuid, timeStamp: dayTimeStamp, runReference: userRunReference)
    
        // -- adding the summaryReference to teamSummaries
        let _teamSummaryReference = dh.addSummaryToTeamSummary(uuid: authorUuid, onDay: dayTimeStamp, team: team, summaryReference: userSummaryReference)
    
        // -- adding the teamSummariesReference to teamDays - this can be done better by instead fetch once at dawn
        let _teamDayReference = dh.addTeamSummaryToDay()
    
        // creating the acticity in userActivities
        let userActivityReference = dp.publishActivity(title: title, authorUuid: authorUuid, userRunReference: userRunReference, postComment: postComment, painComment: painComment, publiclyVisible: publiclyVisible, curTimeStamp: curTimeStamp)
    
        // adding the activityReference to recentActivities
        // use the cur timestamp
        if (publiclyVisible) {
          let _ = dh.addToRecentActivities(activity: userActivityReference, timeStamp: curTimeStamp)
        }
    
        // creating the userDay in userDayInfo
        // using activityreference (appending)
        let _userDayInfoReference = dp.publishDayInfo(authorUuid: authorUuid, dayTimeStamp: dayTimeStamp, sleep: 0.0, activityReference: userActivityReference, activityTimeStamp: curTimeStamp)
    
        // adding the userDayReference to teamDay
    
    
        // adding the teamDayReference to the team
    
    
        // add the dayInfoReference to Day
    }
}
