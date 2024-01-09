//
//  MainView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import SwiftUI
import NukeUI

enum MainViewStates {
    case noAccounts
    case normal
}

struct MainView: View {
    
    @StateObject var settings = Settings()
    @StateObject var accountsManager = AccountsManager()
    
    @State var selectedViewTag: String = "settings"
    
    @State var status: MainViewStates = .noAccounts
    
    var body: some View {
        
        
        
        
        
        
        TabView(selection: $selectedViewTag){
            AccountsView()
                .environmentObject(settings)
                .environmentObject(accountsManager)
                .tag("settings")
                .tabItem{
                    Label("Settings", systemImage: "house.fill")
                }
            
            ForEach(accountsManager.connections){ connection in
                ConnectionView(connection: connection)
                    .environmentObject(settings)
                    .environmentObject(accountsManager)
                    .tag(connection.serverAccount.username)
                    .background {
                        Color(cgColor: connection.serverAccount.color.cgColor)
                            .opacity(0.4)
                            .ignoresSafeArea()
                    }
            }
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .safeAreaInset(edge: .top, spacing: 0) {
            Picker("Account",selection: $selectedViewTag) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 32,height:32)
                    .tag("settings")
                ForEach(accountsManager.connections){ connection in
                    
                    Group{
                        Text(connection.serverAccount.instanceURL.host() ?? "-")
                        
                    }
                    //                            .frame(width:32,height:32)
                    .tag(connection.serverAccount.username)
                }
            }.pickerStyle(.segmented)
        }
        
    }
}
