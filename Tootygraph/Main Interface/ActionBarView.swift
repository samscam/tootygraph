//
//  BottomBar.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 06/02/2023.
//

import Foundation

import SwiftUI
import TootSDK

struct ActionBarView: View {
    @State var showingSettings: Bool = false
    @State var showingPostComposer: Bool = false
    @Environment(\.tootClient) var tootClient: TootClient?
    @Environment(\.palette) var palette: Palette
    @Namespace var geometryEffectNamespace
    
    var body: some View {
        HStack{
            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(palette.highlight)
                    .frame(width: 40,height:40)
                    .padding(10)
            }
            .popover(isPresented: $showingSettings){
                AccountsView(geometryEffectNamespace: geometryEffectNamespace)}
            
            Spacer()
            Button {
                showingPostComposer.toggle()
            } label: {
                Image(systemName: "paperplane.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(palette.highlight)
                    .frame(width: 40,height:40)
                    .padding(10)
            }
            .popover(isPresented: $showingPostComposer){
                PostComposerView(showingComposer: $showingPostComposer, viewModel: PostComposerViewModel(tootClient: tootClient))
            }
            
        }
        .background(Material.bar)
        
        
    }
}

#Preview(traits:.sizeThatFitsLayout) {
    @State var showingPostComposer: Bool = false
    
    return ActionBarView(showingPostComposer: showingPostComposer)
}
