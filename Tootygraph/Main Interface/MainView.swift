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
    
    @State var currentBackground: AnyShapeStyle = AnyShapeStyle(Color.background)
    

    // This is for defocussing the add account field from AddServerView.swift - it is unpleasant that it's here but hey, whatevs
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
                    .tag(connection.account.id)
                    .palette(connection.palette)
                    .tint(connection.palette.highlight)
                
            }

            
        }
        .background{
            ZStack {
                Rectangle()
                    .fill(currentBackground)
                
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
                    currentBackground = AnyShapeStyle(connection.palette.background)
                    fieldFocussed = false
                }
            } else {
                withAnimation{
                    currentBackground = AnyShapeStyle(Color.background)
                }
            }
        })
        
        
        .tabViewStyle(.page(indexDisplayMode: .never))
        .if(accountsManager.connections.count > 0, transform: { view in
            view.safeAreaInset(edge: .top,alignment: .center,spacing:0) {
                VStack{
                    TopBarView(selectedViewTag: $selectedViewTag)
                        .environmentObject(accountsManager)
                    
                }
            }
        })
        
    }
}


