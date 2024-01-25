//
//  TabbedView.swift
//  Tootygraph
//
//  Created by Sam on 21/01/2024.
//

import Foundation
import SwiftUI
import NukeUI
import Boutique
import TootSDK

struct TabbedView: View {
    
    @EnvironmentObject var settings: SettingsManager

    @State var currentPalette: Palette = Palette.standard()
    
    @State var selectedTimeline: TimelineController? = nil

    @Binding var connections: [ConnectionController]
    
    var body: some View {

        TabView(selection: $selectedTimeline){
            ForEach(connections){ connection in
                ForEach(connection.timelines){ timeline in
                    TimelineView(timelineController: timeline)
                    // .palette(timeline.connection.palette)
                }
            }

            
        }
        .background{
            ZStack {
                Rectangle()
                    .fill(currentPalette.background)
                
                Image("wood-texture")
                    .resizable()
                    .saturation(0)
                    .blendMode(.multiply)
                    .opacity(0.3)
                
            }.ignoresSafeArea()
        }
//        .onChange(of: selectedViewTag, {
//            if let connection = accountsManager[selectedViewTag] {
//                withAnimation{
//                    currentPalette = connection.palette
//                }
//            } else {
//                withAnimation{
//                    currentPalette = Palette.standard()
//                }
//            }
//        })
        
        
        .tabViewStyle(.page(indexDisplayMode: .never))
        .safeAreaInset(edge: .bottom,alignment: .center,spacing:0) {
            if connections.count > 0 {
                VStack{
                    
                        TabBarView(selectedTimeline: $selectedTimeline, connections: connections)
                            .palette(currentPalette)
                    
                }
            }
        }
        
        .safeAreaInset(edge: .top,alignment: .center,spacing:0) {
            ActionBarView()
//                .environment(\.tootClient, selectedTimeline?.tootClient)
                .palette(currentPalette)
        }
        
    }
}

#Preview {
    let account: FediAccount = FediAccount(
        id: "someid",
        username: "sam",
        hue: .random(in: 0...1),
        instanceURL: URL(string: "https://togl.me")!,
        accessToken: nil,
        userAccount: Account(
            id: "arrg",
            acct: "dunno",
            url: "https://example.foo",
            note: "no notes",
            avatar: "https://togl.me/system/accounts/avatars/109/331/181/925/532/108/original/4f663b6f6802cac5.jpeg",
            header: "https://togl.me/system/accounts/headers/109/331/181/925/532/108/original/cc4bcf8745fae566.jpg",
            headerStatic: "static",
            locked: false,
            emojis: [],
            createdAt: Date(),
            postsCount: 1023,
            followersCount: 123,
            followingCount: 432,
            fields: []))
    @State var connections: [ConnectionController] = [
        ConnectionController(account:account)
    ]
    return TabbedView(connections: $connections)
}
