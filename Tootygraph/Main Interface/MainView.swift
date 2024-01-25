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
    
    @Namespace var geometryEffectNamespace
    
    @EnvironmentObject var accountsManager: AccountsManager
    
    
    var body: some View {
        Group{
            
            switch accountsManager.loadState {
            case .starting:
                SplashView(geometryEffectNamespace: geometryEffectNamespace, splashMessage: "Starting up")
            case .error(let error):
                SplashView(geometryEffectNamespace: geometryEffectNamespace, splashMessage: error.localizedDescription)
            case .loaded:
                if (accountsManager.connections.count == 0) {
                    AccountsView(geometryEffectNamespace: geometryEffectNamespace)
                        .palette(Palette.standard())
                        .tag("settings")
                } else {
                    TabbedView(connections: $accountsManager.connections)
                    
                }
            case .message(let message):
                
                SplashView(geometryEffectNamespace: geometryEffectNamespace,splashMessage: message)
            }
            
        }.animation(.default, value: accountsManager.loadState)
    }
}


