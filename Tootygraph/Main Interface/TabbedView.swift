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
    @EnvironmentObject var accountsManager: AccountsManager
    
    @State var currentPalette: Palette = Palette.standard()
    
    @State var selectedFeed: UUID? = nil
    
    @Binding var connections: [Connection]
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        
        SwipeableTabView(selection: $selectedFeed){
            ForEach(connections){ connection in
                ConnectionView(connection: connection).palette(connection.palette)
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
        .onChange(of: selectedFeed, initial: true) {
            guard let selectedFeed else {
                return
            }
            guard let palette = accountsManager.connectionContaining(feedID: selectedFeed)?.palette else {
                withAnimation{
                    currentPalette = .standard()
                }
                return
            }
            withAnimation{
                currentPalette = palette
            }
            
        }
        .palette(currentPalette)
        .flippingBar(flipped: verticalSizeClass == .compact, orientation: .bottomLeading){
            feedSelectionBar
        }
        .flippingBar(flipped: verticalSizeClass == .compact, orientation: .topTrailing){
            ActionBarView(horizontal: verticalSizeClass == .regular)
               .palette(currentPalette)
       }
        
    }
    
    var feedSelectionBar: some View {
        Group{
            if connections.count > 0 {
                VStack{
                    TabBarView(selectedFeed: $selectedFeed, horizontal: verticalSizeClass == .regular, connections: connections)
                        .palette(currentPalette)
                    
                }
            }
        }
    }
}


struct FeedIdentifier: Hashable, Equatable {
    let account: String
    let timeline: String
    
    static var unknown: FeedIdentifier {
        FeedIdentifier(account: "unknown", timeline: "unknown")
    }
}


#Preview {
    let account = Account.testAccount
    let settings = SettingsManager()
    let accountsManager = AccountsManager()
    
    @State var connections: [Connection] = [
        Connection(account:account)
    ]
    
    return TabbedView(connections: $connections)
        .environmentObject(settings)
        .environmentObject(accountsManager)
}
