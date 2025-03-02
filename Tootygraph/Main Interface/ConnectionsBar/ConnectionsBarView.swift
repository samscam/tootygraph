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

struct ConnectionsBarView: View {
//    @Environment(AccountsManager.self) var accountsManager: AccountsManager
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

#Preview {
    @Previewable @State var selectedFeed: UUID? = nil
    @Previewable @State var connections: [Connection] = [
        Connection(account:FediAccount.Samples.sam)
    ]
    
    ConnectionsBarView(selectedFeed: $selectedFeed, horizontal: true, connections: connections).palette(.random())
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
