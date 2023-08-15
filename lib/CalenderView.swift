import SwiftUI
import Combine

struct CalendarView: View {
  @EnvironmentObject var settings: UserSettings
  @State var curDate: Date = Date()
  @State var showPopup: Bool = false
  @State var selectedDate = -1
  
  var body: some View {
    ScrollView {
      if selectedDate < 0 {
        VStack {
          CalendarTitle
          CalendarIcons
        }
      } else {
        getSummaryView()
      }
    }
    .navigationBarTitle("Calendar")
    .sheet(isPresented: $showPopup) {
      LoggingView(callerReference: self)
    }
    .navigationBarItems(trailing: Button(action: {
      self.showPopup = true
    }, label: {
      Image(systemName: "plus")
    }))
  }
  
  var CalendarTitle: some View {
    let monthLabel = CalendarHelper().monthString(date: curDate) + " " + CalendarHelper().yearString(date: curDate)
    
    return HStack {
      Button {
        self.curDate = CalendarHelper().minusMonth(date: curDate)
      } label: {
        Text("<")
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(Color.black)
      }
      .frame(width: 40, height: 40)
      .background(Color.gray)
      .cornerRadius(10)
      .padding(.leading, 20)
      
      Spacer()
      
      Text("\(monthLabel)")
        .font(.system(size: 24, weight: .bold, design: Font.Design.default))
      
      Spacer()
      
      Button {
        self.curDate = CalendarHelper().plusMonth(date: curDate)
      } label: {
        Text(">")
          .font(.system(size: 20, weight: .bold, design: Font.Design.default))
          .foregroundColor(Color.black)
      }
      .frame(width: 40, height: 40)
      .background(Color.gray)
      .cornerRadius(10)
      .padding(.trailing, 20)
    }
  }
  
  var CalendarIcons: some View {
    let monthData: [String] = getMonthView(selectedDate: curDate)
    
    let screenSize = UIScreen.main.bounds
    let screenWidth: CGFloat = screenSize.width
    //let screenHeight: CGFloat = screenSize.height
    let width: CGFloat = (screenWidth - 2) / 8
    let height: CGFloat = width
    
    return VStack {
      ForEach(0...5, id: \.self) { r in
        HStack {
          ForEach(0...6, id: \.self) { c in
            Button(action: {
              selectedDate = Int(monthData[7*r+c]) ?? -1
            }) {
              Text("\(monthData[(7*r+c)])")
                .foregroundColor(Color.black)
                .font(.system(size: 18, weight: .bold, design: Font.Design.default))
            }
            .frame(width: width, height: height)
            .background(.red)
            .clipShape(Circle())
            //.padding(5)
          }
        }
      }
    }
  }
  
  func getSummaryView() -> some View {
    
    let usedDate = Calendar.current.date(bySetting: .day, value: selectedDate, of: curDate)
    
    let curTimeStamp = UserHelper().getCurTimeStamp(date: usedDate!)
    //let wrappedDayInfo = DataFetching().getDayInfo(uuid: settings.uuid, date: curTimeStamp, dayInfoRef: nil)
    
    let curDayInfo: DayInfo? = {
      do {
        return nil
        //return try wrappedDayInfo.get()
      } catch {
        return nil
      }
    }();
    
    return ZStack {
      
      Rectangle()
        .foregroundStyle(.linearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .topTrailing))
      
      VStack {
        
        HStack {
          Text("\(CalendarHelper().monthString(date: curDate)) \(self.selectedDate)")
            .font(.system(size: 24))
            .padding(.leading, 10)
          
          Spacer(minLength: .zero)
          
          Text("PVA: -1")
            .padding(5)
          
          Button {
            
          } label: {
            HStack {
              Text("add sleep")
              Image(systemName: "plus")
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.black)
            .cornerRadius(10)
          }
          .padding(5)
        }
        
        if let curInfo = curDayInfo {
          ForEach(curInfo.runs) { runRef in
            //let wrappedRun = DataFetching().getRun(uuid: "", date: 0, runRef: runRef)
            let run: Run? = {
              do {
                return nil
                //return try wrappedRun.get()
              } catch {
                return nil
              }
            }();
            
            if let realRun = run {
              AnyView(summaryEntry(run: realRun))
            }
          
          }
        }
          
        Button {
          self.selectedDate = -1
        } label: {
          Text("Go back")
            .padding()
            .foregroundColor(Color.white)
            .background(Color.black)
            .cornerRadius(10)
        }
        .frame(alignment: .trailing)
      }
      //.background(Color.gray)
      //.frame(idealWidth: screenWidth, idealHeight: screenHeight)
      .cornerRadius(10)
    }
  }
  
  func summaryEntry(run: Run) -> some View {
    ZStack {
      Rectangle()
        .foregroundStyle(.gray)
        .cornerRadius(10)
      
      VStack {
        Text("You ran \(String(format: "%.2f", run.miles)) miles and felt \(String(format: "%.1f", run.pain)) pain")
          .padding()
      }
    }
  }
    
  func getMonthView(selectedDate: Date) -> [String] {
    var totalSquares = [String]()
    
    let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
    let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
    let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
    
    var count: Int = 1
    while(count <= 42) {
      if(count <= startingSpaces || count - startingSpaces > daysInMonth) {
        totalSquares.append("")
      } else {
        totalSquares.append(String(count - startingSpaces))
      }
      count += 1
    }
    
    return totalSquares
  }
  
  func closePopUp() {
    showPopup = false
  }
}

#if DEBUG
struct CalenderView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CalendarView()
        .environmentObject(UserSettings())
    }
  }
}
#endif
