



class DataThroughPut {

    func publishAndUpdateActivity(authorUuid: String, title: String, milage: Double, pain: Double, postComment: String, painComment: String, date: Date, team: String, publiclyVisible: Bool, curTimeStamp: String, dayTimeStamp: String) {
    
        let db = Firestore.firestore()
        let dp = DataPublishing()
        
        // creating the run in userRuns
        let userRunReference = dp.publishRun(uuid: authorUuid, timeStamp: curTimeStamp, milage: milage, pain: pain)
    
        // creating the summary in userSummaries
        let userSummaryReference = dp.publishSummary(uuid: authorUuid, timeStamp: dayTimeStamp, runReference: userRunReference)
    
        // -- adding the summaryReference to teamSummaries
        let teamSummaryReference = dp.addSummaryToTeamSummary(uuid: authorUuid, onDay: dayTimeStamp, team: team, summaryReference: userSummaryReference)
    
        // -- adding the teamSummariesReference to teamDays - this can be done better by instead fetch once at dawn
        let teamDayReference = dp.addTeamSummaryToDay()
    
        // creating the acticity in userActivities
        let userActivityReference = dp.publishActivity(title: title, authorUuid: authorUuid, userRunReference: userRunReference, postComment: postComment, painComment: painComment, publiclyVisible: publiclyVisible, curTimeStamp: curTimeStamp)
    
        // adding the activityReference to recentActivities
        // use the cur timestamp
        if (publiclyVisible) {
            let _ = dp.addToRecentActivities(userActivityReference)
        }
    
        // creating the userDay in userDayInfo
        // using activityreference (appending)
        let userDayInfoReference = dp.publishDayInfo(authorUuid: authorUuid, dayTimeStamp: dayTimeStamp, sleep: 0.0, activityReference: userActivityReference, activityTimeStamp: curTimeStamp)
    
        // adding the userDayReference to teamDay
    
    
        // adding the teamDayReference to the team
    
    
        // add the dayInfoReference to Day
    }
}