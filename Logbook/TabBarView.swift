import SwiftUI

struct TabbarView: View {
  @EnvironmentObject var settings: UserSettings
  let dataManager: DataManager = DataManager()
  
  var body: some View {
    TabView {
      NavigationView {
        FeedContentView()
          .environmentObject(self.dataManager)
      }
      .tag(0)
      .tabItem {
        Image("activity-1")
          .resizable()
        Text("Feed")
      }
      
      NavigationView {
        CalendarView()
      }
      .tag(1)
      .tabItem {
        Image("calender")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 25, height: 25)
        Text("Calender")
      }
      
      if (self.settings.isCoach) {
        NavigationView {
          CoachView()
        }
        .tag(2)
        .tabItem {
          Image("activity-1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
          Text("Coach's Corner")
        }
      }
      
      NavigationView {
        AccountView()
      }
      .tag(3)
      .tabItem {
        Image("profile-glyph-icon")
        Text("Account")
      }
    }
  }
}

#if DEBUG
struct TabbarView_Previews: PreviewProvider {
  static var previews: some View {
    let settings = UserSettings()
    TabbarView().environmentObject(settings)
  }
}
#endif
