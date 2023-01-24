//
//  CoachView.swift
//  Logbook
//
//  Created by Evan Stokdyk on 12/25/22.
//  Copyright © 2022 NexThings. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

// this constructs a way to pull and veiw days for a given team
struct CoachView: View {
  @EnvironmentObject var settings: UserSettings
  @State var selectedDate: Date = Date()

  @State var genericBool: Bool = false
  @State var currentDay: Day?


  var body: some View {
    VStack {
      Text("Select a Date")

      // this is where the calendar will go

      DatePicker(selection: self.$selectedDate, displayedComponents: [.date]) {

      }

      // a button to pull the runs for the selected date
      Button(action: {
        do {
          currentDay = try DataFetching().getDay(team: settings.teamName, date: selectedDate).get()
        } catch {
          // do something to handle error
        }
      }) {
        Text("Pull Runs")
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }

      // this is where the list of runs will go
      if let day = currentDay {
        List {
          // still need to figure out how to get the author
          ForEach(day.eachDayInfo) { dayInfoRef in
            let wrappedRealDayInfo = DataFetching().getDayInfo(uuid: "", date: "", dayInfoRef: dayInfoRef)
            
            let realDayInfo: DayInfo? = {
              do {
                return try wrappedRealDayInfo.get()
              } catch {
                return nil // then show error
              }
            }();
            
            if let dayInfo = realDayInfo {
              Text(" -- \(dayInfo.author)) -- ")
              Text("\(dayInfo.sleep) hours of sleep")
              ForEach(dayInfo.runs) { iterRun in
                let wrappedRun = DataFetching().getRun(uuid: "", date: 0, runRef: iterRun)
                let realRun: Run? = {
                  do {
                    return try wrappedRun.get()
                  } catch {
                    return nil // then show error
                  }
                }();
                
                if let run = realRun {
                  Text("> \(run.miles) miles (\(run.pain)/10 pain)")
                }
              }
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
