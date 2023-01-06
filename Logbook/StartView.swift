import SwiftUI

class UserSettings: ObservableObject {
  @Published var loggedIn : Bool = UserDefaults.standard.bool(forKey: UserHelper().LOGGED_IN_KEY)
  @Published var isCoach: Bool = UserDefaults.standard.bool(forKey: UserHelper().IS_COACH_KEY)
  @Published var team: String = UserDefaults.standard.string(forKey: UserHelper().TEAM_KEY) ?? "no team"
  @Published var userName: String = UserDefaults.standard.string(forKey: UserHelper().USER_NAME_KEY) ?? "Null Name"
}

struct StartView: View {
  @EnvironmentObject var settings: UserSettings
  
  var body: some View {
    if settings.loggedIn {
      return AnyView(TabbarView())
    } else {
      return AnyView(UserView().environmentObject(LoginInfo()))
    }
  }
}
