//
//  PhotoComposer.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 26/02/2023.
//

import SwiftUI
import PhotosUI
import TootSDK


struct PostComposerView: View {
    
    @StateObject var viewModel: PostComposerViewModel
    
    init(replyContext: PostWrapper? = nil){
        _viewModel = StateObject(wrappedValue: PostComposerViewModel(tootClient: nil,replyContext: nil))
    }
    
    var body: some View {
        EmptyView()
    }
}

#Preview {
    PostComposerView()
}
