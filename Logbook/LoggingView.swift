import SwiftUI




struct LoggingView: View {
  //could be useful for default choices
  @EnvironmentObject var settings: UserSettings
  
  @State var callerReference: CalendarView
  
  @State var dateOfRun: Date = Date() // Could use a date component specifying that hour and minute and second are 0
  @State var author: String = ""
  @State var distanceRan: String = ""
  @State var painLevel: Int = 0
  @State var postComment: String = ""
  @State var feelingComment: String = ""
  //@State var postComments: String = ""
  @State var publicalyVisible: Bool = true
  @State var feltPain: Bool = false
   
  let screenSize = UIScreen.main.bounds
  let screenWidth: CGFloat = UIScreen.main.bounds.width
  //let screenHeight: CGFloat = screenSize.height
  let standardWidth: CGFloat = UIScreen.main.bounds.width - 40
  //let height: CGFloat = width
  
  //exproting data to spreadsheet

  var body: some View {
    NavigationView {
      VStack (spacing: 0) {
        HStack {
          Text("Date")
          
          //[.date, .hourAndMinute], in: ...Date.now
          //https://developer.apple.com/documentation/swiftui/datepicker
          
          DatePicker(selection: $dateOfRun, displayedComponents: [.date]) {}
          
        }
        .padding()
        
        //.keyboardType(.decimalPad)
        
        HStack {
          Text("Distance: ")
            .padding(.leading, 20)
          
          
          TextField("0.00", text: $distanceRan)
            .keyboardType(.decimalPad)
            .padding(.trailing, 20)
          
          /*
          Picker("", selection: $distanceRan) {
            ForEach(0...20, id: \.self) { dist in
              Text("\(dist)")
            }
          }
           */
          
        }
        
       // Text("Anything cool you want to share")
        
        VStack {
          TextField("What you did", text: self.$postComment)
            .frame(width: standardWidth)
            .accentColor(.red)
          
          textLine
        }
        .padding()
        
        /*
        HStack (alignment: .firstTextBaseline) {
          Text("Did you hurt as all as you ran")
          
          Picker("Distance", selection: $painLevel) {
            ForEach(0...10, id: \.self) { dist in
              Text("\(dist)")
            }
          }
          .padding(.trailing, 20)
        }
         */
        
          
        VStack {
          Toggle(isOn: self.$feltPain) {
            Text("Any pain?")
          }
          .padding(.top, 5)
          
          if (feltPain) {
            Picker("", selection: $painLevel) {
              ForEach(0...10, id: \.self) { pain in
                Text("\(pain)")
              }
            }
            .pickerStyle(.segmented)
            
            TextField("Anything Else", text: self.$feelingComment)
            //.frame(width: standardWidth)
            //.textContentType(textType)
              .accentColor(.red)
              .padding(.bottom, 5)
              //.multilineTextAlignment(.leading)
              .textFieldStyle(.roundedBorder)
              .fixedSize(horizontal: false, vertical: true)
            
          }
          else {
            Spacer()
              .frame(height: 5)
          }
        }
        .padding(.horizontal, 20)
        .background(.white)
        .cornerRadius(10)
        
        
        
        Toggle(isOn: self.$publicalyVisible) {
          Text("Do you want this to be visable to your teammates?")
        }
        .padding()
        
        Button {
          DataThroughPut().publishAndUpdateActivity(authorUuid: settings.uuid, title: "LINE 132 LOGGING VIEW", milage: Double(distanceRan) ?? 0.0, pain: Double(painLevel), postComment: postComment, painComment: feelingComment, date: dateOfRun, team: settings.teamName, publiclyVisible: publicalyVisible, curTimeStamp: UserHelper().getCurTimeStamp(date: Date()), dayTimeStamp: UserHelper().getDayTimeStamp(date: Date()))

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
      .navigationTitle(Text("Record a run"))
    }
  }
  
  var textLine: some View {
    Rectangle().frame(width: standardWidth, height: 2)
  }
}

#if DEBUG
struct LoggingView_Previews: PreviewProvider {
  static var previews: some View {
    LoggingView(callerReference: CalendarView())
  }
}
#endif
