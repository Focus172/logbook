import SwiftUI
import Combine

struct CalendarView: View {
    //@EnvironmentObject var settings: UserSettings
    //@State var chosenDate: UInt8 = 255
    @State var curDate: Date = Date()
    @State var showPopup: Bool = false
    
    
    var body: some View {
        //shownDates.insert(curDate, at: 0)
        //self.shownDates.append(CalendarHelper().minusMonth(date: self.curDate))
        
        return ScrollView {
            VStack {
                AnyView(CalendarTitle(date: curDate))
                AnyView(CalendarIcons(date: curDate))
            }
        }
        .navigationBarTitle("Calendar")
        .sheet(isPresented: $showPopup) {
            let dataManager = DataManager()
            LoggingView(callerReference: self)
                .environmentObject(dataManager)
        }
        .navigationBarItems(trailing: Button(action: {
            self.showPopup = true
        }, label: {
            Image(systemName: "plus")
        }))
    }
    
    func CalendarTitle(date: Date) -> any View {
        let monthLabel = CalendarHelper().monthString(date: date) + " " + CalendarHelper().yearString(date: date)
        
        //let screenSize = UIScreen.main.bounds
        //let screenWidth = screenSize.width
        //let buttonDimensions = screenWidth / 16
        
        return HStack {
            Button {
                self.curDate = CalendarHelper().minusMonth(date: curDate)
            } label: {
                Text("<")
                    .font(.system(size: 20, weight: .bold, design: Font.Design.default))
                    
            }
            .padding(.trailing, 10)

            Text("\(monthLabel)")
                //.foregroundColor(Color.black)
                .font(.system(size: 24, weight: .bold, design: Font.Design.default))
            
            Button {
                self.curDate = CalendarHelper().plusMonth(date: curDate)
            } label: {
                Text(">")
                    .font(.system(size: 20, weight: .bold, design: Font.Design.default))
                    
            }
            .padding(.leading, 10)
            //.frame(width: self.width, height: self.height)
            //.foregroundColor(Color.red)
            //.background(Color.black)
            //.cornerRadius(5)
        }
    }
    
    func CalendarIcons(date: Date) -> any View {
        let monthData: [String] = getMonthView(selectedDate: date)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth: CGFloat = screenSize.width
        //let screenHeight: CGFloat = screenSize.height
        let width: CGFloat = (screenWidth - 2) / 8
        let height: CGFloat = width
        
        return VStack {
            ForEach(0...5, id: \.self) { r in
                //if (monthData[7*r] != "" && monthData[7*r+6] != "") {
                HStack {
                    ForEach(0...6, id: \.self) { c in
                        Button(action: {
                            //get the data for the date
                        }) {
                            Text("\(monthData[(7*r+c)])")
                                .foregroundColor(Color.black)
                                .font(.system(size: 18, weight: .bold, design: Font.Design.default))
                            
                        }
                        .frame(width: width, height: height)
                        .background(Color.red)
                        .clipShape(Circle())
                        //.padding(5)
                    }
                }
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
        let settings = UserSettings()
        NavigationView {
            CalendarView().environmentObject(settings)
        }
    }
}
#endif
