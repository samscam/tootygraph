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
    
    @Binding var selectedFeed: UUID?
    
    let horizontal: Bool
    
    let connections: [Connection]
    
    var body: some View {
        
        ScrollView(horizontal ? .horizontal : .vertical) {
            FlippingStackView(horizontal: horizontal){
                ForEach(connections){ connection in
                    ConnectionLozenge(connection: connection, horizontal: horizontal, selectedFeed: $selectedFeed)
                }
            }.scrollTargetLayout()
                .padding(5)
        }
        .scrollIndicators(.never)
        .scrollClipDisabled(true)
        .scrollTargetBehavior(.viewAligned)
        .background(
            Material.bar
        )
    }
    
}

struct ConnectionLozenge: View {
    let connection: Connection
    let horizontal: Bool
    @Binding var selectedFeed: UUID?
    
    var body: some View {
        FlippingStackView(horizontal: horizontal){
            LazyImage(url: connection.avatarURL){ state in
                if let image = state.image {
                    image.resizable()
                } else {
                    Color.gray
                }
            }
            .frame(width: 42,height:42)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            ForEach(connection.feeds, id:\.id){ feed in
                Button {
                    withAnimation {
                        selectedFeed = feed.id
                    }
                   
                } label: {
                    Image(systemName: feed.iconName)
                        .resizable()
                        
                        .padding(5)
                        .frame(width: 42,height:42)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(connection.palette.background)
                                .stroke(highlightStyle(for: feed.id),lineWidth:4)
                                
                        }
                }
                .buttonStyle(.plain)
                .tint(connection.palette.highlight)
            }
        }
        .padding(5)
        .background{
            RoundedRectangle(cornerRadius: 10)
//                .stroke(lozengeStyle)
                .blur(radius: 2)
        }
    }
    
//    @MainActor
//    var lozengeStyle: some ShapeStyle {
//        
//        let background: AnyShapeStyle
//        if let selectedFeed,
//           selectedFeed.account == connection.account.niceName {
//            background = AnyShapeStyle(connection.palette.highlight)
//        } else {
//            background = AnyShapeStyle(connection.palette.postBackground)
//        }
//        return background
//    }
//    
    @MainActor
    func highlightStyle(for feed: UUID) -> some ShapeStyle{
        if let selectedFeed,
           selectedFeed == feed {
            return AnyShapeStyle(connection.palette.highlight)
        } else {
            return AnyShapeStyle(.clear)
        }
    }
}


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
