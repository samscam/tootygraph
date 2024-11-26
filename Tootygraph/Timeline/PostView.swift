//
//  StatusView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 05/02/2023.
//

import SwiftUI
import NukeUI
import Boutique
import TootSDK


struct PostView: View {
    
    @Environment(\.palette) var palette: Palette
    @EnvironmentObject var settings: SettingsManager
    
    var post: PostController
    
    @State var showingReplySheet: Bool = false
    
    
    var body: some View{

        VStack(alignment: .leading, spacing: 0) {
//            NavigationLink(value: post.feedFor(post.displayPost.account)) {
                AvatarView(account: post.displayPost.account)
                    .padding(.bottom,20)
//            }
  
            
            VStack(alignment: .center,spacing:0){
                ForEach(post.mediaAttachments){ media in
                    
                    let index = post.mediaAttachments.firstIndex(of: media)!
                    let jaunty = post.jauntyAngles[index+2]
//                    NavigationLink(value: media){
                        
                        PhotoView(media: media)
                            .rotationEffect(Angle(degrees: settings.jaunty ? jaunty : 0))
//                    }
                    
                        .if(index == post.mediaAttachments.count-1){
                            $0.padding(.bottom,20)
                        }
                        .if(!settings.jaunty && index < post.mediaAttachments.count-1){
                            $0.padding(.bottom,20)
                        }
                    
                }
            }
            .frame(maxWidth: .infinity,alignment: .center)
                .zIndex(4)
                .padding(.horizontal,-30)
            
            if settings.showContent{
                textContent
                    .if(post.mediaAttachments.count > 0){
                        $0.padding(.top,-20)
                    }
                    .padding(.bottom,15)
                    .zIndex(0)
            }
            
            actionButtons
            
            
        }
        .padding(15)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(palette.postBackground)
        }
        .overlay(alignment: .topTrailing){
            if let booster = post.booster {
                NavigationLink(value: post.feedFor(booster) ) {
                    AvatarImage(url: URL(string:booster.avatar))

                        .rotationEffect(.degrees(15))
                        .frame(width:40,height:40)
                        
                }
            }
        }
        .padding(.horizontal,10)

    }
    
    
    var textContent: some View {
        
        Text(post.attributedContent)
            .font(.body)
//            .font(.custom("AmericanTypewriter",size:18))
            .multilineTextAlignment(.leading)
            .layoutPriority(10)
            .frame(maxWidth: .infinity,alignment: .leading)
            .foregroundColor(.primary)
            .if(post.mediaAttachments.count > 0){
                $0.padding(.top,20)
            }
    }
    
    var compactTextContent: some View {
        Text(post.attributedContent)
            .lineLimit(4, reservesSpace: false)
            .font(.custom("AmericanTypewriter",size:14))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity,alignment: .leading)
            .foregroundColor(.primary)
    }
    
    var actionButtons: some View {
        HStack(spacing:10){
            ActionButtonView(highlighted: false, actionType: .reply) {
                showingReplySheet = true
            }.frame(width:40,height:40)
            Spacer()
            ActionButtonView(highlighted: post.displayPost.favourited ?? false, actionType: .favourite) {
                Task{
                    try await post.toggleFavourite()
                }
            }.frame(width:40,height:40)
            ActionButtonView(highlighted: post.displayPost.reposted ?? false, actionType: .boost) {
                Task{
                    try await post.toggleBoost()
                }
            }.frame(width:40,height:40)
        }
        .sheet(isPresented: $showingReplySheet, content: {
            PostComposerView(showingComposer: $showingReplySheet, viewModel: PostComposerViewModel(tootClient: post.client, replyContext: post))
        })
    }
    
}


#if DEBUG
#Preview(traits: .sizeThatFitsLayout){
    let settings = {
        let settings = SettingsManager()
        settings.$jaunty.set(false)
        settings.$showContent.set(true)
        return settings
    }()
    let palette = Palette.random()
    
    let postWrapper = PostController(TestPosts.justText)
    
    return PostView(post: postWrapper).environmentObject(settings)
            .palette(palette)
            .background(palette.background)
    
    
    
}

#Preview(traits: .sizeThatFitsLayout){
    let settings = {
        let settings = SettingsManager()
        settings.$jaunty.set(true)
        settings.$showContent.set(true)
        return settings
    }()
    let palette = Palette.random()
    
    let postWrapper = PostController(TestPosts.postWithPics)
    return PostView(post: postWrapper)
            .palette(palette)
            .environmentObject(settings)
            .padding()
            .background(palette.background)
    
    
    
}

#endif

