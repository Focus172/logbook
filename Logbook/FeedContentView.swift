import SwiftUI
import Combine

struct Post {
    var id: Int
    var title: String
    var author: String
    var milage: Double
    var description: String
}

class FeedPost: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var postCollection: [Post] {
        willSet {
             objectWillChange.send()
         }
    }
    
    init(data: [Post]) {
        self.postCollection = data
    }
}

struct FeedContentView: View {
  @EnvironmentObject var settings: UserSettings
  @State var currentActivities: [Activity]?
  //@State var postHighlighted: Activitiy? = nil
  
  /*
   HStack (spacing: 40) {
    Text("a")
      .font(.title)
      .multilineTextAlignment(.center)

    Text("a")
      .font(.body)
      .fontWeight(.semibold)
   }
   */
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                
                HStack {
                    
                    Text("Recent posts by teammates")
                        .padding()
                        .font(.system(size: 20))
                        .onAppear {
                          /*
                          DataBulk().getActivities(limitTo: 5) { activities, errors in
                            guard errors.isEmpty else {
                              return
                              // do something
                            }
                            
                            currentActivities = activities
                          }
                           */
                        }
                    
                    Button {
                      
                      print("clicked")
                      DataBulk().getActivities(limitTo: 5) { activities, errors in
                        /*
                        guard errors.isEmpty else {
                          return
                          // do something
                        }
                         */
                        
                        print("3")
                        
                        currentActivities = activities
                        print("\(activities.description)")
                      }
                    } label: {
                      Image(systemName: "trash")
                    }

                    
                }
              if let acts = currentActivities {
                ForEach(acts) { act in
                  //print("\(act.description)")
                  AnyView(RunningActivityView(activity: act))
                }
              }
              
              
            }
            //.navigationBarTitle("Feed")
        }
    }
  
  func ErrorView(error: Error?) -> any View {
    return Text("error")
  }
}



struct RunningActivityView: View {
    
    var activity: Activity
    
    var body: some View {
        VStack (alignment: .leading) {
            

          Text("title: \(activity.comment)")
                .font(.system(size: 18))
                .padding(.leading, 10)
                .padding(.top, 10)
                
            HStack {
                Text("@\(activity.author)")
                    .font(.system(size: 14))
                    .italic()
        
                //Image("activity-1").renderingMode(.original)
            }
            .offset(x: 20)
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.linearGradient(colors: [.red, .pink], startPoint: .topLeading, endPoint: .topTrailing))
                
                VStack (alignment: .leading) {
                  Text("private comment: \(activity.privateComment)")
                        //.padding(.bottom, 5)
                  //Text("\(activity.run.miles) mi")
                }
                .padding()
            }
        }
        .background(Color.gray)
        .cornerRadius(10)
        .padding(.bottom)
    }
    
}


#if DEBUG
struct FeedContentView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = UserSettings()
        NavigationView {
            FeedContentView()
                .environmentObject(settings)
        }
    }
}
#endif
