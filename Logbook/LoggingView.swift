import SwiftUI

struct LoggingView: View {
    //could be useful for default choices
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var dataManager: DataManager
    
    @State var callerReference: CalendarView
    
    @State var dateOfRun: Date = Date()
    @State var author: String = ""
    @State var distanceRan: Int = 0
    @State var painLevel: Int = 0
    @State var postComment: String = ""
    @State var feelingComment: String = ""
    //@State var postComments: String = ""
    @State var publicalyVisible: Bool = true
     
    //exproting data to spreadsheet

    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Text("Date")
                    DatePicker(selection: $dateOfRun, in: ...Date.now, displayedComponents: .date) {
                    }
                }
                .padding()
                
                HStack {
                    Text("Distance: ")
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    Picker("Distance", selection: $distanceRan) {
                        ForEach(0...20, id: \.self) { dist in
                            Text("\(dist)")
                        }
                    }
                    .padding(.trailing, 20)
                }
                
                Text("Anything cool you want to share")
                TextField("Add a comment for your run", text: self.$postComment)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                
                
                HStack (alignment: .firstTextBaseline) {
                    Text("Did you hurt as all as you ran")
                    
                    Picker("Distance", selection: $painLevel) {
                        ForEach(0...10, id: \.self) { dist in
                            Text("\(dist)")
                        }
                    }
                    .padding(.trailing, 20)
                }
                
                TextField("Want to add anything else", text: self.$feelingComment)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                
                Toggle(isOn: self.$publicalyVisible) {
                    Text("Do you want this to be visable to your teammates?")
                }
                .padding()
                
                Button {
                  dataManager.publishActivity(title: "Line 71 LoggingView", date: dateOfRun, uuid: settings.uuid, milage: Double(distanceRan), pain: Double(painLevel), postComment: postComment, feelingComment: feelingComment, publiclyVisible: publicalyVisible)
                    callerReference.closePopUp()
                } label: {
                    Text("Do the thing")
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(20)
                }
                .padding(.bottom, 40)
                //.offset(x: 100, y: -180)

                
                Spacer()
                
                
            }
            .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
            .navigationTitle(Text("Record your run!"))
        }
        
    }
}

/*
 #if DEBUG
 struct LoggingView_Previews: PreviewProvider {
 static var previews: some View {
 //LoggingView()
 }
 }
 #endif
 */
