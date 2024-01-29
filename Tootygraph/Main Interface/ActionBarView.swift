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
    
    let horizontal: Bool
    
    var body: some View {
        FlippingStackView(horizontal: horizontal){
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
                AccountsView()
            }
            
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
    
    return ActionBarView(showingPostComposer: showingPostComposer, horizontal: true)
}
