import SwiftUI
import FirebaseAuth

class LoginInfo: ObservableObject {
  @Published var onLogin: Bool = true
  @Published var userName: String = ""
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var isCoach: Bool = false
  @Published var teamName: String = ""
  //@Published var uuid: String?
}

struct UserView: View {
  @EnvironmentObject var logInfo: LoginInfo
  @EnvironmentObject var settings: UserSettings
  @EnvironmentObject var dataManager: DataManager
  
  let screenSize = UIScreen.main.bounds
  let screenWidth: CGFloat = UIScreen.main.bounds.width
  //let screenHeight: CGFloat = screenSize.height
  let standardWidth: CGFloat = UIScreen.main.bounds.width - 40
  //let height: CGFloat = width
  
  var body: some View {
    if (self.logInfo.onLogin) {
      LogInView().environmentObject(logInfo)
    } else {
      SignUpView().environmentObject(logInfo)
    }
  }
  
  func LogInView() -> some View {
    
    ZStack {
      //Color.black
      
      VStack (alignment: .center) { //, spacing: 20) {
        //Spacer().frame(height: 20)
        
        ZStack {
          Rectangle()
            .foregroundColor(.red)
            .frame(width: 500, height: 200)
            .offset(y: -100)
          
          Rectangle()
            .foregroundColor(.red)
            .frame(width: 500, height: 200)
            
          VStack {
            //Spacer()
            
            Text("Logbook")
              .font(.system(size: 30, weight: .bold))
              .foregroundColor(.white)
              .padding()
            
            Text("Log Into Your Account")
              .font(.title)
              .foregroundColor(.white)
              .font(.system(size: 14, weight: .bold, design: Font.Design.default))
              .padding()
          }
        }
            
        textField(name: "Email", content: $logInfo.email, textType: .emailAddress, isSecure: false)
        
        textField(name: "Password", content: $logInfo.password, textType: .password, isSecure: true)
        
        Button {
          let _ = login()
        } label: {
          Text("Log In")
            .padding()
            .frame(width: standardWidth, height: 40)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(5)
        }
        //.padding(.top, 20)
        //.onAppear {
        //    Auth.auth().addStateDidChangeListener{ auth, user in
        //        if user != nil {
        //            self.settings.loggedIn.toggle()
        //        }
        //    }
        //}
        //.padding(.bottom, 40)
        
        Button {
          self.logInfo.onLogin = false
        } label: {
          Text("Don't have an account? Sign Up!")
            .bold()
            .frame(width: standardWidth, height: 40)
            .foregroundColor(Color.blue)
            .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
            .cornerRadius(5)
        }
        //.padding(.top, 20)
        
        Spacer()

      }
    }
    //.ignoresSafeArea()
  }
  
  func SignUpView() -> some View {
    //@Environment(\.colorScheme) var colorScheme
    
    ZStack {
      //Color.white
      
      Rectangle()
        .foregroundColor(.black) //colorScheme == .light ? .black : .white)
        .frame(width: 1000, height: 400)
        .rotationEffect(Angle(degrees: -40))
        .offset(y: 400)
      
      Rectangle()
        .foregroundColor(.red)
        .frame(width: 1000, height: 100)
        .rotationEffect(Angle(degrees: -40))
        .offset(y: 200)
      
      VStack { //(alignment: .center)
      
        HStack {
          Image("profile-glyph-icon")
            .resizable()
            .frame(width: 20, height: 20)
          Text("Logbook")
            .font(.system(size: 12))
          
        }
        .padding(.top)
        
        Text("Create an Account")
          .font(.title)
          .font(.system(size: 14, weight: .bold, design: Font.Design.default))
          .padding(.bottom)
        
        /*
         Button(action: {
         print("Add photo")
         }) {
         VStack(alignment: .center) {
         Text("+")
         .font(.system(size: 18))
         Text("Add Photo")
         .font(.system(size: 10))
         }.padding()
         .frame(width: 100, height: 100)
         .foregroundColor(Color.white)
         .background(Color.blue)
         }
         .clipShape(Circle())
         .padding(.bottom, 10)
         */
        
        HStack {
          Button {
            logInfo.isCoach = false
          } label: {
            Text("I'm an athelte")
              .frame(width: 150, height: 50)
              .background(!logInfo.isCoach ? Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255) : .white)
                //Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
          }
          
          Button {
            logInfo.isCoach = true
          } label: {
            Text("I'm a coach")
              .frame(width: 150, height: 50)
              //.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
              .background(logInfo.isCoach ? Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255) : .white)
          }
        }
        
        textField(name: "Name", content: $logInfo.userName, textType: .name, isSecure: false)
        
        textField(name: "Email", content: $logInfo.email, textType: .emailAddress, isSecure: false)
        
        textField(name: "Password", content: $logInfo.password, textType: .password, isSecure: true)
        
        textField(name: "Team Name", content: $logInfo.teamName, textType: .name, isSecure: false)
        
        /*
        if () { // logInfo.isCoach
          // do one thing
        } else {
          // do another thing
        }
         */
        
        HStack {
          Button {
            logInfo.onLogin = true
          } label: {
            Text("Go Back")
              .padding()
              .foregroundColor(Color.blue)
              .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
              .cornerRadius(20)
          }
          .padding()
          
          Spacer()
            .frame(width: standardWidth/5)
          
          Button {
            register()
          } label: {
            Text("Create Account")
              .padding()
              .foregroundColor(Color.white)
              .background(Color.blue)
              .cornerRadius(20)
          }
          .padding()
        }
        
        
        Spacer()
        
      }
    }
  }
  
  func textField(name: String, content: Binding<String>, textType: UITextContentType, isSecure: Bool) -> some View {
    
    return VStack {
      if isSecure {
        SecureField(name, text: content)
          .frame(width: standardWidth)
          .textContentType(textType)
          .accentColor(.red)
          .disableAutocorrection(true) // may not be nessisary
          .autocapitalization(.none) // may not be nessisary
      } else {
        TextField(name, text: content)
          .frame(width: standardWidth)
          .textContentType(textType)
          .accentColor(.red)
          .disableAutocorrection(true)
          .autocapitalization(.none)
      }
    
      Rectangle().frame(width: standardWidth, height: 2)
    }
    .padding()
    
      //.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
      //.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
  }
      
  
  func login() -> Bool {
    
    // value to report for if display should update error
    var loginSucsess = false
    
    // sign them in the make sure they are who they say
    Auth.auth().signIn(withEmail: logInfo.email, password: logInfo.password) { result, error in
      guard error == nil else {
        print(error!.localizedDescription)
        // TODO: something should be done here to let the user know how they messed up
        return
      }
      
      // grab their uuid from their email
      if let uuid = dataManager.getUuid(email: logInfo.email) {
        // grab their user profile from their uuid
        let user = dataManager.getUser(uuid: uuid)

        // do all happy path actions
        updateInstance(uuid: uuid, userName: user.userName, teamName: user.teamName, isCoach: user.isCoach)
        UserHelper().logIn(settings: settings)
        loginSucsess = true
      }
    
    }
    
    return loginSucsess
  }
      
  func register() {
    
    Auth.auth().createUser(withEmail: logInfo.email, password: logInfo.password) { result, error in
      guard error == nil else {
        print(error!.localizedDescription)
        return
      }
      
      // generate a semi-random uuid
      let uuid = Date().description.sha256().prefix(10).description
      
      // publish to server and push user through
      dataManager.publishUser(uuid: uuid, email: logInfo.email, userName: logInfo.userName, isCoach: logInfo.isCoach, teamName: logInfo.teamName)
      updateInstance(uuid: uuid, userName: logInfo.userName, teamName: logInfo.teamName, isCoach: logInfo.isCoach)
      UserHelper().logIn(settings: settings)
    }
  }
  
    
  func updateInstance(uuid: String, userName: String, teamName: String, isCoach: Bool) {
    // reference to the user defaults
    let ref = UserDefaults.standard
    
    // set uuid
    ref.set(uuid, forKey: Strings.UUID_KEY)
    settings.uuid = uuid
    
    // set userName
    ref.set(userName, forKey: Strings.USER_NAME_KEY)
    settings.userName = userName
    
    // set teamName
    ref.set(teamName, forKey: Strings.TEAM_KEY)
    settings.teamName = teamName
    
    // set isCoach
    ref.set(isCoach, forKey: Strings.IS_COACH_KEY)
    settings.isCoach = isCoach
    
  }
  
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    UserView()
      .environmentObject(UserSettings())
      .environmentObject(LoginInfo())
  }
}
#endif


