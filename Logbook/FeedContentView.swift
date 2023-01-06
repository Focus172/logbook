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
    @EnvironmentObject var dataManager: DataManager
    //@ObservedObject var postData : FeedPost
    //@State var isShowing: Bool = false
    //@State var postHighlighted: FeedPlaces? = nil
    
    
    
    var body: some View {
        return ScrollView{
            VStack(alignment: .leading) {
                
                HStack {
                    
                    Text("Recent posts by teammates")
                        .padding()
                        .font(.system(size: 20))
                  /*
                        .onAppear{
                            dataManager.getActivity()
                        }
                   */
                    
                    Button {
                        dataManager.getActivities()
                    } label: {
                        Image(systemName: "trash")
                    }

                    
                }
              
              // funny quirk here, when two items have the same id
              // one will show twice and the other zero times
                ForEach(self.dataManager.activities ?? [], id: \.id) { activity in
                    
                    RunningActivityView(activity: activity)
                    
                }
            }
            //.navigationBarTitle("Feed")
        }
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
                  Text("\(activity.run.miles) mi")
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
        let dataManager = DataManager()
        NavigationView {
            FeedContentView()
                .environmentObject(settings)
                .environmentObject(dataManager)
        }
    }
}
#endif
