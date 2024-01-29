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
    @Environment(\.palette) var palette: Palette
    @Binding var selectedTimeline: FeedIdentifier?
    let connections: [Connection]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack{
                ForEach(connections){ connection in
                    ConnectionLozenge(connection: connection, selectedFeed: $selectedTimeline)
                }
            }.padding(5)
        }
        .background(
            Material.bar
        )
    }
    
}

struct ConnectionLozenge: View {
    let connection: Connection
    @Binding var selectedFeed: FeedIdentifier?
    
    var body: some View {
        HStack{
            LazyImage(url: connection.avatarURL){ state in
                if let image = state.image {
                    image.resizable()
                } else {
                    Color.gray
                }
            }
            .frame(width: 42,height:42)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            ForEach(connection.timelines){ timeline in
                Button {
                    withAnimation {
                        selectedFeed = timeline.id
                    }
                   
                } label: {
                    Image(systemName: timeline.timeline.iconName)
                        .resizable()
                        
                        .padding(5)
                        .frame(width: 42,height:42)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(connection.palette.background)
                                .stroke(highlightStyle(for: timeline.id),lineWidth:4)
                                
                        }
                }
                .buttonStyle(.plain)
                .tint(connection.palette.highlight)
            }
        }
        .padding(5)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .stroke(lozengeStyle)
                .blur(radius: 2)
        }
    }
    
    @MainActor
    var lozengeStyle: some ShapeStyle {
        
        let background: AnyShapeStyle
        if let selectedFeed,
           selectedFeed.account == connection.account.niceName {
            background = AnyShapeStyle(connection.palette.highlight)
        } else {
            background = AnyShapeStyle(connection.palette.postBackground)
        }
        return background
    }
    
    @MainActor
    func highlightStyle(for feed: FeedIdentifier) -> some ShapeStyle{
        if let selectedFeed,
           selectedFeed == feed {
            return AnyShapeStyle(connection.palette.highlight)
        } else {
            return AnyShapeStyle(.clear)
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
