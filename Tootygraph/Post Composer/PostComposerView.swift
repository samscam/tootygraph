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
    @Binding var showingComposer: Bool
    @Environment(\.palette) var palette: Palette
    @StateObject var viewModel: PostComposerViewModel
    @FocusState var focus: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            
            if let replyContext = viewModel.replyContext{
                Text("Reply to:").font(.caption)
                VStack(alignment: .leading){
                    AvatarView(account: replyContext.displayPost.account)
                    Text(replyContext.attributedContent).lineLimit(2, reservesSpace: false)
                        .font(.custom("AmericanTypewriter",size:14))
                }
                .frame(maxWidth: .infinity)
                .padding(15)
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(palette.postBackground)
                }
            } else {
                Text("Compose a post...").font(.caption)
            }
            TextEditor( text: $viewModel.composedText)
                .focused($focus)
                .font(.custom("AmericanTypewriter",size:18))
                .frame(maxHeight:.infinity)
                .textEditorStyle(.plain)
                .padding(5)
                .background{
                    RoundedRectangle(cornerRadius: 10).fill(palette.postBackground)
                }.tint(.white)
            
            HStack{
                
                Text("\(viewModel.remainingChars)")
                Spacer()
                Button("Post") {
                    Task{
                        try await viewModel.post()
                        showingComposer = false
                    }
                }.buttonStyle(.borderedProminent)
            }
        }.padding()
            .background{
                Rectangle()
                    .fill(palette.background)
                    .ignoresSafeArea()
            }
            .onAppear {
                focus = true
            }
    }
}

#Preview {
    @State var showingComposer: Bool = true
    let palette = Palette(0.7)
    let viewModel = PostComposerViewModel(tootClient: nil)
    viewModel.composedText = "This is some sample text which we have already writte for the preview"
    return PostComposerView(showingComposer: $showingComposer, viewModel: viewModel)
        .palette(palette)
    
}
