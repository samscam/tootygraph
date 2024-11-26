//
//  MainView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import SwiftUI
import NukeUI
import Boutique


struct MainView: View {
    
    // GIVEN that we are waiting to find out about the various accounts, and they have not connected yet, it should show a splash screen
    
    // GIVEN that no accounts have been set up
    // THEN it should show the settings screen
    
    // GIVEN that there are one-or-more accounts
    // THEN it should show the Tabbed interface
    @Environment(AccountsManager.self) var accountsManager: AccountsManager

    var body: some View {
        Group{
            switch accountsManager.loadState {
            case .starting:
                SplashView(splashMessage: "Starting up")
            case .error(let error):
                SplashView(splashMessage: error.localizedDescription)
            case .loaded:
                if (accountsManager.connections.count == 0) {
                    AccountsView()
                        .palette(Palette.standard())
                        .tag("settings")
                } else {
                    TabbedView(connections: accountsManager.connections)
//                    Text("Whoops")
                    
                }
            case .message(let message):
                
                SplashView(splashMessage: message)
            }
            
        }
//        .animation(.default, value: accountsManager.loadState)
    }
}


