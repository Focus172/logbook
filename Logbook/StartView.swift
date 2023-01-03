import SwiftUI
//import Firebase

class UserSettings: ObservableObject {
    @Published var loggedIn : Bool = UserDefaults.standard.bool(forKey: "loggedIn")
    @Published var isCoach: Bool = UserDefaults.standard.bool(forKey: "isCoach")
    @Published var team: String = UserDefaults.standard.string(forKey: "team") ?? "no team"
    @Published var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "Null Name"
}

class SendToLogin: ObservableObject {
    @Published var goToLogin: Bool = true
}

struct StartView: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        if settings.loggedIn {
            return AnyView(TabbarView())
        } else {
            //let login = SendToLogin()
            return AnyView(UserView()
                .environmentObject(SendToLogin()))
        }
    }
}

#if DEBUG
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = UserSettings()
        StartView()
            .environmentObject(settings)
    }
}
#endif
