import SwiftUI

class UserSettings: ObservableObject {
  @Published var loggedIn : Bool = UserDefaults.standard.bool(forKey: Strings.LOGGED_IN_KEY)
  @Published var isCoach: Bool = UserDefaults.standard.bool(forKey: Strings.IS_COACH_KEY)
  @Published var teamName: String = UserDefaults.standard.string(forKey: Strings.TEAM_KEY) ?? "invalidTeam"
  @Published var userName: String = UserDefaults.standard.string(forKey: Strings.USER_NAME_KEY) ?? "invalidName"
  @Published var uuid: String = UserDefaults.standard.string(forKey: Strings.UUID_KEY) ?? "invalidUUID"
}

struct StartView: View {
  @EnvironmentObject var settings: UserSettings
  let dataManager: DataManager = DataManager()
  
  var body: some View {
    if settings.loggedIn {
      AnyView(
        TabbarView()
          .environmentObject(dataManager)
      )
    } else {
      AnyView(
        UserView()
          .environmentObject(LoginInfo())
          .environmentObject(dataManager)
      )
    }
  }
}
