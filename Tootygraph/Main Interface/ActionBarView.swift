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
    
    @State var showingPostComposer: Bool = false
    @Environment(\.tootClient) var tootClient: TootClient?
    @Environment(\.palette) var palette: Palette
    
    var body: some View {
        HStack{
            Spacer()
            Image(systemName: "paperplane.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(palette.highlight)
                .frame(width: 40,height:40)
                .padding(10)
                .onTapGesture {
                    showingPostComposer.toggle()
                }
                .popover(isPresented: $showingPostComposer){
                    PostComposerView(showingComposer: $showingPostComposer, viewModel: PostComposerViewModel(tootClient: tootClient))                }
            Spacer()
        }
        .background(Material.bar)
        
        
    }
}

#Preview(traits:.sizeThatFitsLayout) {
    @State var showingPostComposer: Bool = false
    
    return ActionBarView(showingPostComposer: showingPostComposer)
}
