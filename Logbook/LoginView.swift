import SwiftUI
import FirebaseAuth

class LoginInfo: ObservableObject {
  @Published var onLogin: Bool = true
  @Published var userName: String = ""
  @Published var emailAddress: String = ""
  @Published var password: String = ""
  @Published var isCoach: Bool = false
  @Published var teamName: String = ""
}

struct UserView: View {
  @EnvironmentObject var logInfo: LoginInfo
  @EnvironmentObject var settings: UserSettings
  
  var body: some View {
    if (self.logInfo.onLogin) {
      LogInView().environmentObject(logInfo)
    } else {
      SignUpView().environmentObject(logInfo)
    }
  }
  
  func LogInView() -> some View {
    ZStack {
      Color.black
      
      Rectangle()
        .foregroundColor(.red)
        .frame(width: 500, height: 200)
        .offset(y: -350)
      
      VStack (alignment: .center, spacing: 20) {
        Spacer().frame(height: 20)
        
        Text("Logbook")
          .font(.system(size: 30, weight: .bold))
          .foregroundColor(.white)
          .padding()
        
        Text("Log Into Your Account")
          .font(.title)
          .foregroundColor(.white)
          .font(.system(size: 14, weight: .bold, design: Font.Design.default))
          .padding(.bottom, 50)
            
        TextField("Username", text: $logInfo.userName)
          .frame(width: 300, height: 60)
          .textContentType(.emailAddress)
          .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
          .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
          .cornerRadius(10)
            
            
        SecureField("Password", text: $logInfo.password)
          .frame(width: 300, height: 60)
          .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
          .foregroundColor(.gray)
          .background(Color.white)
          .textContentType(.password)
          .cornerRadius(10)
            
        Button {
          login()
        } label: {
          Text("Log In")
            .padding()
            .frame(width: 300, height: 40)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(5)
        }
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
            .frame(width: 300, height: 40)
            .foregroundColor(Color.blue)
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding(.bottom, 40)
        
        Spacer()

      }
      .padding(.bottom, 90)
    }
    .ignoresSafeArea()
  }
      
  func login() {
    Auth.auth().signIn(withEmail: logInfo.emailAddress, password: logInfo.password) { result, error in
      if error != nil {
        print(error!.localizedDescription)
      } else {
        self.settings.loggedIn = true
      }
    }
  }
  
  func SignUpView() -> some View {
    ZStack {
      Color.white
      
      Rectangle()
        .foregroundColor(.black)
        .frame(width: 1000, height: 400)
        .rotationEffect(Angle(degrees: -40))
        .offset(y: 400)
      
      Rectangle()
        .foregroundColor(.red)
        .frame(width: 1000, height: 100)
        .rotationEffect(Angle(degrees: -40))
        .offset(y: 200)
      
      VStack (alignment: .center) {
        HStack {
          Image("profile-glyph-icon")
            .resizable()
            .frame(width: 20, height: 20)
          Text("Logbook")
            .font(.system(size: 12))
        }.padding(.top, 100)
        
        Text("Create an Account")
          .font(.title)
          .font(.system(size: 14, weight: .bold, design: Font.Design.default))
          .padding(.bottom, 20)
        
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
              .background(!logInfo.isCoach ? .gray : .white)
                //Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
          }
          
          Button {
            logInfo.isCoach = true
          } label: {
            Text("I'm a coach")
              .frame(width: 150, height: 50)
              //.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
              .background(logInfo.isCoach ? .gray : .white)
          }
        }
        
        signUpViewContent()
        
        if (logInfo.isCoach) {
          VStack(alignment: .leading) {
            TextField("Team Name", text: $logInfo.teamName)
              .frame(width: 350, height: 50)
              .textContentType(.emailAddress)
              .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
              .accentColor(.red)
            
            textLine
          }
        } else {
          //this should be more about joining teams
          VStack(alignment: .leading) {
            TextField("Team Name", text: $logInfo.teamName)
              .frame(width: 350, height: 50)
              .textContentType(.emailAddress)
              .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
              .accentColor(.red)
            
            textLine
          }
        }
        
        Spacer()
        
        Button {
          register()
        } label: {
          Text("Create Account")
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(20)
        }
        .padding(.bottom, 40)
        .offset(x: 100, y: -180)
      }
    }.ignoresSafeArea()
  }
      
  func register() {
    Auth.auth().createUser(withEmail: logInfo.emailAddress, password: logInfo.password) { result, error in
      if error != nil {
        print(error!.localizedDescription) // this should provide feedback for why their logging in failed
      }
    }
    createUserDefaults()
    
    // LogInView().login() // this should be able to log the person in
    
    self.settings.loggedIn = true
  }
    
  func createUserDefaults() {
    let ref = UserDefaults.standard
    ref.set(true, forKey: "loggedIn")
    ref.set(logInfo.isCoach, forKey: "isCoach")
    ref.set(logInfo.teamName, forKey: "team")
    ref.set(logInfo.userName, forKey: "userName")
  }
      
  var textLine: some View {
    return Rectangle().frame(width: 250, height: 2).offset(y: -20)
  }
      
  func signUpViewContent() -> some View {
    return VStack(alignment: .leading) {
      TextField("Name", text: $logInfo.userName)
        .frame(width: 350, height: 50)
        .textContentType(.emailAddress)
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
        .accentColor(.red)
        //.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
        
      textLine
        
      TextField("Email", text: $logInfo.emailAddress)
        .frame(width: 350, height: 50)
        .textContentType(.emailAddress)
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
        .accentColor(.red)
        //.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
        
      textLine
        
      SecureField("Password", text: $logInfo.password)
        .frame(width: 350, height: 50)
        .textContentType(.password)
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
        .accentColor(.red)
        //.background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
        
      textLine
    }
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


