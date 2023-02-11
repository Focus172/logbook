//
//  CoachUserView.swift
//  Logbook
//
//  Created by Evan Stokdyk on 1/31/23.
//  Copyright © 2023 NexThings. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct CoachUserView: View {
  
  @State var userRef: DocumentReference?
  @State var curUser: User?
  
  @State var curDate: Date = Date()
  
  @State var curDayInfo: DayInfo?
  
  var body: some View {
    VStack {
      
      if let readyUser = curUser {
        DatePicker(selection: self.$curDate) {
          // information about what it is
        }
        
        Button {
          DataFetching().getDayInfo(uuid: readyUser.uuid, date: UserHelper().getDayTimeStamp(date: curDate)) { dayinfo, error in
            
            guard error == nil else {
              // do somthing
              return
            }
            
            if let di = dayinfo {
              self.curDayInfo = di
            }
          }
            
        } label: {
          Text("fetch for a specific date")
        }

        
        Text("team: \(readyUser.team)")
        Text("email: \(readyUser.email)")
        Text("uuid: \(readyUser.uuid)")
        
        if let curDayInfo = curDayInfo {
          Text("got the day info VVV")
          Text("sleep: \(curDayInfo.sleep)")
        }
        
      } else {
        Text("User is loading be patient. If this persist then the user likely doesn't exist")
      }
    }
    .onAppear{
      
      DataFetching().getUser(uuid: "", selectedUser: userRef) { user, error in
        guard error == nil else {
          // do something
          return
        }
        
        if let user = user {
          print(user.uuid)
          self.curUser = user
        }
      }
    }
    
    
  }
}
