//
//  TabbedView.swift
//  Tootygraph
//
//  Created by Sam on 21/01/2024.
//

import Foundation
import SwiftUI
import NukeUI
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

    @Environment(SettingsManager.self) var settings: SettingsManager?
    
    @State private var currentPalette: Palette = Palette.standard()
    
    @State private var selectedTab: Tabs = .home
    
    @State private var selectedFeed: UUID? = nil
    
    @State var connections: [Connection]
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    var body: some View {
        ZStack{
            Image("wood-texture")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            NavigationStack{
                CustomTabView(selection:$selectedFeed){
                    
                    ForEach(accountsManager.connections){ connection in
                        ConnectionView(connection: connection)
                    }
                    
                }
                .safeAreaInset(edge: .bottom) {
                    ConnectionsBarView(selectedFeed: $selectedFeed, connections: accountsManager.connections)
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
    @Previewable
    @State var connections: [Connection] =
    [Connection(account:FediAccount.Samples.alpaca)]
    
    
//    let account = FediAccount.Samples.alpaca
    
    let settings = SettingsManager()
    let tootygraph = Tootygraph()
    let accountsManager = AccountsManager(
        modelContainer: tootygraph.modelContainer,
        settings: settings
    )
    
    
    
    TabbedView(connections: connections)
        .environment(settings)
        .environment(accountsManager)
    
}
