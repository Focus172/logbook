
/*
import SwiftUI
import Combine

struct Conversation {
    var id: Int
    var name: String
    var messageChain: MessageStream
}

struct MessageStream {
    var messages: [Message]
    var lastMessage: Date
}

struct Message {
    var id: Int
    var user: String
    var timeStamp: Date
    var content: String
}

class ConversationStream : ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var conversationCollection: [Conversation] {
        willSet {
             objectWillChange.send()
         }
    }
    
    init(data: [Conversation]) {
        self.conversationCollection = data
    }
}

class ConversationSelected: ObservableObject {
    @Published var index: Int = -1
}

struct CoachMessengerView: View {
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var messageData : ConversationStream
    @ObservedObject var conversationSelected: ConversationSelected = ConversationSelected()
    
    var body: some View {
        GeometryReader { g in
            VStack {
                if (conversationSelected.index == -1) {
                    ForEach(self.messageData.conversationCollection, id: \.id) { item in
                        Button(action: {
                            self.conversationSelected.index = item.id
                            //ConversationView(conversation: item)
                        }) {
                            Text(item.name)
                        }
                    }
                } else {
                    ConversationView(conversation: self.messageData.conversationCollection[conversationSelected.index])
                }
            }
        }
    }
}

struct ConversationView: View {
    var conversation : Conversation
    
    var body: some View {
        VStack {
            ForEach(self.conversation.messageChain.messages, id: \.id) { item in
                Text(item.content)
            }
        }
    }
}

*/
