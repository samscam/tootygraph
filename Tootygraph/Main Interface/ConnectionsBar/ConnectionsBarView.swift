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

    @Environment(\.palette) var palette: Palette
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Binding var selectedFeed: UUID?
    @State var showingSettings: Bool = false
    
    @State var expanded: Bool = true
    
    var horizontal: Bool {
        horizontalSizeClass == .compact
    }
    
    let connections: [Connection]
    
    var body: some View {
        Group{
            if expanded {
                    VStack(alignment:.leading){
                        ForEach(connections){ connection in
                            HStack{
                                AvatarImage(url: connection.avatarURL)
                                    .frame(width: 56,height:56)
                                Text(connection.account.niceName)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth:.infinity)
                                
                            }.padding(4)
                                .background(connection.palette.background)
                        }
                        expandControl
                    }.padding()
                
            } else {
                ScrollView(horizontal ? .horizontal : .vertical) {
                    
                    FlippingStackView(horizontal: horizontal){
                        expandControl
                        ForEach(connections){ connection in
                            ConnectionLozenge(connection: connection, horizontal: horizontal, selectedFeed: $selectedFeed)
                        }
                        
                        Button("settings", systemImage: "umbrella.fill"){
                            // show settings
                            showingSettings = true
                        }.labelStyle(.iconOnly)
                        
                    }.scrollTargetLayout()
                        .padding(5)
                    
                    
                }
                .scrollIndicators(.never)
                .scrollClipDisabled(true)
                .scrollTargetBehavior(.viewAligned)
            }

        }
        .background(
            Material.bar
        )
        .popover(isPresented: $showingSettings){
           AccountsView()
       }
    }
    
    var expandControl: some View {
        Image(systemName: "arrow.up.and.person.rectangle.turn.left")
            .resizable()
            .foregroundStyle(.black)
            .frame(width:40,height:40)
            .padding().onTapGesture {
                expanded = !expanded
            }
    }
}

#Preview {
    @Previewable @State var selectedFeed: UUID? = nil
    @Previewable @State var connections: [Connection] = [
        Connection(account:FediAccount.Samples.sam),
        Connection(account:FediAccount.Samples.alpaca)
        
    ]
    
    ConnectionsBarView(selectedFeed: $selectedFeed, connections: connections).palette(.random())
    
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
