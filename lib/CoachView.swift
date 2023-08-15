//
//  CoachView.swift
//  Logbook
//
//  Created by Evan Stokdyk on 12/25/22.
//  Copyright © 2022 NexThings. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

// this constructs a way to pull and view days for a given team
struct CoachView: View {
  @EnvironmentObject var settings: UserSettings
  @State var selectedDate: Date = Date()

  @State var genericBool: Bool = false
  
  @State var currentUsers: [UserPreview]?
  @State var currentError: Error?
  
  @State var selectedUser: User?
  
  var body: some View {
    VStack {
      //Text("Select a Date")
      
      // this is where the calendar will go
      //picker("thing", selection: self.$selectedDate, displayedComponents: [.date])

      // a button to pull the runs for the selected date
      Button(action: {
        DataBulk().getTeamUsers(team: "hw") { users, error in
          guard error == nil else {
            // do something
            print("error oh no!")
            return
          }
          
          //print("users: \(users?.description)")
          currentUsers = users
        }
        
      }) {
        Text("Get Users")
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }

      // this is where the list of runs will go
      if let users = currentUsers {
        Form {
          
          ForEach(users, id: \.uuid) { user in
            NavigationLink {
              
              CoachUserView(userRef: user.refToFull)
              
            } label: {
              Text(" -- \(user.name) -- ")
            }
            
          }
        }
        .padding()
      }
          
    }.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
      .navigationBarTitle("Coach View")
  }
  

}

#if DEBUG
struct CoachView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView{
      CoachView()
        .environmentObject(UserSettings())
    }
  }
}
#endif
