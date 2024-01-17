//
//  DetailView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 08/02/2023.
//

import SwiftUI
import NukeUI
import TootSDK


struct DetailView: View {
  
  let post: PostManager
  let selectedMedia: MediaAttachment?
  
  @State private var dragOffset = CGSize.zero

  var body: some View{
    ScrollView{
      VStack{
        AvatarView(account: post.post.account)

        ForEach(post.post.mediaAttachments) { media in
          
            PhotoView(media: media)

          Spacer(minLength: 40)

        }
        
          Text(post.attributedContent)
            .font(.custom("AmericanTypewriter",size:24))
            .foregroundColor(.black)
            .opacity(0.8)
            .multilineTextAlignment(.leading)
            .padding()
            .background{
              Rectangle()
                .foregroundColor(.yellow.opacity(0.7))
            }
        
      }.padding()
    }
    .navigationTitle("From \(post.post.account.displayName ?? "--")")
    .background{
      Image("wood-texture").resizable().edgesIgnoringSafeArea(.all)
    }
  }
}

