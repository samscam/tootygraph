//
//  MainView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import SwiftUI
import NukeUI
import Boutique

enum MainViewStates {
    case noAccounts
    case normal
}

struct MainView: View {
    
    @StateObject var settings = SettingsManager()
    @StateObject var accountsManager = AccountsManager()
    
    @State var selectedViewTag: String = "settings"
    @State var currentPalette: Palette = Palette.standard()
    

    // This is for defocussing the add account field from AddServerView.swift - it is unpleasant that it's here but hey, whatevs
    @FocusState var fieldFocussed: Bool
    
    
    var body: some View {
        
        

        
        TabView(selection: $selectedViewTag.animation()){
            
            AccountsView(fieldFocussed: $fieldFocussed, selectedViewTag: $selectedViewTag)
                .environmentObject(settings)
                .environmentObject(accountsManager)
                .palette(Palette.standard())
                .tag("settings")
            
            ForEach(accountsManager.connections){ connection in
                ConnectionView(connection: connection)
                    .environmentObject(settings)
                    .environmentObject(accountsManager)
                    .tag(connection.account.id)
                    .palette(connection.palette)
                
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
        .onChange(of: selectedViewTag, {
            if let connection = accountsManager[selectedViewTag] {
                withAnimation{
                    currentPalette = connection.palette
                    fieldFocussed = false
                }
            } else {
                withAnimation{
                    currentPalette = Palette.standard()
                }
            }
        })
        
        
        .tabViewStyle(.page(indexDisplayMode: .never))
        .safeAreaInset(edge: .bottom,alignment: .center,spacing:0) {
            if accountsManager.connections.count > 0 {
                VStack{
                    TabBarView(selectedViewTag: $selectedViewTag)
                        .environmentObject(accountsManager)
                        .palette(currentPalette)
                    
                }
            }
        }
        
        .safeAreaInset(edge: .top,alignment: .center,spacing:0) {
            if selectedViewTag != "settings" {
                VStack{
                    ActionBarView()
                        .environment(\.tootClient, accountsManager[selectedViewTag]?.tootClient)
                        .palette(currentPalette)
                    
                }
            }
        }
        
    }
}


