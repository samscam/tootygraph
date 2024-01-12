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
    @State var currentBackground: Color = .background
    
    @State var status: MainViewStates = .noAccounts
    
    @FocusState var fieldFocussed: Bool
    
    var body: some View {
        
        
        TabView(selection: $selectedViewTag.animation()){
            AccountsView(fieldFocussed: $fieldFocussed, selectedViewTag: $selectedViewTag)
                .environmentObject(settings)
                .environmentObject(accountsManager)
                .tag("settings")
                
            
            ForEach(accountsManager.connections){ connection in
                ConnectionView(connection: connection)
                    .environmentObject(settings)
                    .environmentObject(accountsManager)
                    .tag(connection.serverAccount.niceName)
                    .tint(connection.serverAccount.hue.foreground)
                
            }
            
        }
        .background(currentBackground
            .opacity(0.4)
            .ignoresSafeArea(.all))
        .onChange(of: selectedViewTag, {
            if let connection = accountsManager[selectedViewTag] {
                withAnimation{
                    currentBackground = connection.serverAccount.hue.background
                    fieldFocussed = false
                }
            } else {
                withAnimation{
                    currentBackground = .background
                }
            }
        })
        
        
        .tabViewStyle(.page(indexDisplayMode: .never))
        .if(accountsManager.connections.count > 0, transform: { view in
            view.safeAreaInset(edge: .top,alignment: .center,spacing:0) {
                
                
                
                Picker("Account",selection: $selectedViewTag.animation()) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 32,height:32)
                        .tag("settings")
                    ForEach(accountsManager.connections){ connection in
                        
                        Group{
                            Text(connection.serverAccount.username)
                        }
                        .tag(connection.serverAccount.niceName)
                    }
                }.pickerStyle(.segmented)
                    .padding()
                    .background(Material.bar)
                
            }
        })
        
        .onAppear {
            Task{
                try await accountsManager.connectAll()
            }
        }
    }
}
