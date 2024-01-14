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

struct StatusView: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var post: PostWrapper
    let geometry: GeometryProxy?
    
    var body: some View{

        VStack(alignment: .leading, spacing: 0) {
            
            AvatarView(account: post.displayPost.account)
                .padding(.bottom,20)
            
            VStack(alignment: .center,spacing:0){
                ForEach(post.mediaAttachments){ media in
                    
                    let index = post.mediaAttachments.firstIndex(of: media)!
                    let jaunty = post.jauntyAngles[index+2]
                    
                    PhotoView(media: media)
                        .rotationEffect(Angle(degrees: settings.jaunty ? jaunty : 0))
                    // These are currently commented out - because they mess up other aspects of
                    // scaling the photo frames... :/
                    //           .frame(maxWidth: geometry.size.width * 0.9)
                    //           .frame(maxHeight: geometry.size.height * 0.9)
                    
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
                .fill(Color.gray.opacity(0.3))
        }
        .padding(.horizontal,10)
        //        .padding(.bottom,20)
        //
        //    }
        
    }
    
    
    var textContent: some View {
        
        Text(post.attributedContent)
            .font(.custom("AmericanTypewriter",size:18))
            .multilineTextAlignment(.leading)
            .layoutPriority(10)
            .frame(maxWidth: .infinity,alignment: .leading)
            .foregroundColor(.primary)
            .if(post.mediaAttachments.count > 0){
                $0.padding(.top,20)
            }
            
            
    }
    
    var actionButtons: some View {
        HStack(spacing:10){
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
    }
    
}

#Preview(traits: .sizeThatFitsLayout){
    let settings = {
        var settings = Settings()
        settings.$jaunty.set(false)
        settings.$showContent.set(true)
        return settings
    }()
    
    let postWrapper = PostWrapper(TestPosts.justText)
    return StatusView(post: postWrapper, geometry: nil).environmentObject(settings)
    
    
}

#Preview(traits: .sizeThatFitsLayout){
    let settings = {
        var settings = Settings()
        settings.$jaunty.set(false)
        settings.$showContent.set(true)
        return settings
    }()
    
    let postWrapper = PostWrapper(TestPosts.postWithPics)
    return StatusView(post: postWrapper, geometry: nil).environmentObject(settings).padding()
    
    
}
