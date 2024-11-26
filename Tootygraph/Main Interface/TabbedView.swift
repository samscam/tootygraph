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

enum Tabs: String, Equatable, Hashable, Identifiable {
    case settings
    case profile
    case home
    case replies
    
    var id: Int {
        switch self {
        case .settings: 0
        case .home: 1
        case .profile: 2
        case .replies: 3
        }
    }
    
    var name: String {
        self.rawValue.capitalized
    }
}

struct TabbedView: View {
    
    @Environment(AccountsManager.self) var accountsManager: AccountsManager

    @EnvironmentObject var settings: SettingsManager
    
    @State private var currentPalette: Palette = Palette.standard()
    
    @State private var selectedTab: Tabs = .home
    
    @State var connections: [Connection]
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    var body: some View {

        TabView {
            Tab("Settings", systemImage: "gearshape") {
                AccountsView()
            }
            ForEach(accountsManager.connections){ connection in
                TabSection(connection.account.niceName) {
                    Tab("Home", systemImage: "house"){
                        if let home = connection.homeFeed {             FeedView(feed:home)
                        }
                    }
                    Tab("Notifications", systemImage: "text.bubble"){
                        if let replies = connection.notificationsFeed{
                            FeedView(feed:replies)
                        }
                    }
                }
            }
        }

        .tabViewStyle(.sidebarAdaptable)
        
        .background{
            ZStack {
                Rectangle()
                    .fill(currentPalette.background)
                
                Image("wood-texture")
                    .resizable()
                    .saturation(0)
                    .blendMode(.hardLight)
                    .opacity(0.8)
                
            }.ignoresSafeArea()
        }
    }
}

var feedSelectionBar: some View {
    Group{
        
        VStack{
            Text("Everything is brok")
            //                    TabBarView(selectedFeed: $selectedFeed, horizontal: verticalSizeClass == .regular, connections: connections)
            //                        .palette(currentPalette)
            
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
    @Previewable
    @State var connections: [Connection] =
    [Connection(account:Account.testAccount)]
    
    
    let account = Account.testAccount
    let settings = SettingsManager()
    let tootygraph = Tootygraph()
    let accountsManager = AccountsManager(modelContainer: tootygraph.modelContainer)
    
    
    
    TabbedView(connections: connections)
        .environmentObject(settings)
    
}
