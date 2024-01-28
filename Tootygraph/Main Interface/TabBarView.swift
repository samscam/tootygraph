//
//  TopBar.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 03/09/2023.
//

import Foundation
import SwiftUI
import TootSDK
import NukeUI

struct TabBarView: View {
    
    @EnvironmentObject var accountsManager: AccountsManager
    @Binding var selectedTimeline: String?
    let connections: [Connection]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack{
                ForEach(connections){ connection in
                    
                    LazyImage(url: connection.avatarURL){ state in
                        if let image = state.image {
                            image.resizable()
                        } else {
                            Color.gray
                        }
                    }
                    .frame(width: 52,height:52)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}
/**
//                    .if(connection.timelines.contains(selectedTimeline)){
//                        $0.overlay{
//                            
//                            let highlight = connection.palette.highlight
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(highlight, lineWidth: 4)
//                            
//                        }
//                    }
                    
                    ForEach(connections){ timeline in
                        Image(systemName: timeline.timeline.iconName)
                        
                    }
//                    .opacity(connection.account.id != selectedViewTag 0.7)
                    
//                    .onTapGesture {
//                        withAnimation(.spring(duration:0.2)) {
//                            selectedTimeline = connection.account.id
//                        }
//                    }
                    
//                    .tag(connection.account.id)
                }
            }
        }
        .scrollClipDisabled()
        .padding(10)
        .background(
            Material.bar
        )
        
    }
}

//#Preview {
//    let accountsManager = AccountsManager()
//    @State var selectedViewTag: String = "preferences"
//    
//    return TabBarView(selectedViewTag: $selectedViewTag).environmentObject(accountsManager)
//}
 */

extension Timeline {
    var iconName: String {
        switch self {
            
        case .home:
            return "house.fill"
        case .local(_):
            return "bicycle"
        case .federated(_):
            return "sailboat.fill"
        case .favourites:
            return "heart.fill"
        case .bookmarks:
            return "bookmark.fill"
        case .hashtag(_):
            return "number.square.fill"
        case .list(_):
            return "list.bullet.clipboard"
        case .user(_):
            return "person.fill"
        }
    }
}
