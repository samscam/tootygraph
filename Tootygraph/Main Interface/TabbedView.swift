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
    
    @State var selectedTimeline: String? = nil
    
    @Binding var connections: [Connection]
    
    var body: some View {
        
        TabView(selection: $selectedTimeline){
            ForEach(connections){ connection in
                
                ForEach(connection.timelines){ timeline in
                    
                    TimelineView(timelineController: timeline)
                        .tabItem {
                            Label(timeline.timeline.stringName, systemImage: timeline.timeline.iconName)
                        }
//                        .tag(timeline.name)
                    
                }.palette(connection.palette)
            }
            
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
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
        .onChange(of: selectedTimeline) {
            guard let selectedTimeline else { return }
            guard let palette = accountsManager[selectedTimeline]?.palette else {
                withAnimation{
                    currentPalette = .standard()
                }
                return
            }
            withAnimation{
                currentPalette = palette
            }
            
        }.palette(currentPalette)
        
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
//                    .environment(\.tootClient, selectedTimeline?.tootClient)
                    .palette(currentPalette)
            }
        
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

struct MagicTabViewStyle: TabViewStyle{
    static func _makeView<SelectionValue>(value: _GraphValue<_TabViewValue<MagicPagedTabViewStyle, SelectionValue>>, inputs: _ViewInputs) -> _ViewOutputs where SelectionValue : Hashable {
        return Text("hello")
    }
    
    static func _makeViewList<SelectionValue>(value: _GraphValue<_TabViewValue<MagicPagedTabViewStyle, SelectionValue>>, inputs: _ViewListInputs) -> _ViewListOutputs where SelectionValue : Hashable {
        return Text("listView")
    }
    
    
}
