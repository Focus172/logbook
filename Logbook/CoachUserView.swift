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
  
  var body: some View {
    VStack {
      
      if let readyUser = curUser {
        Text("team: \(readyUser.team)")
        Text("email: \(readyUser.email)")
        Text("uuid: \(readyUser.uuid)")
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
