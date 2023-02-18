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
  
  let post: PostWrapper
  let selectedMedia: Attachment
  let photoNamespace: Namespace.ID
  let accountNamespace: Namespace.ID
  
  @State private var dragOffset = CGSize.zero

  var body: some View{
    ScrollView{
      VStack{
        AvatarView(account: post.wrappedPost.account)
//          .matchedGeometryEffect(id: post.wrappedPost.account.id, in: accountNamespace)

        ForEach(post.wrappedPost.mediaAttachments) { media in
          
            PhotoFrame(media: media)
//              .matchedGeometryEffect(id: media.id, in: photoNamespace)
          
          Spacer(minLength: 40)

        }
        if let parsedContent = post.attributedContent {
          Text(parsedContent)
            .font(.custom("AmericanTypewriter",size:24))
            .foregroundColor(.black)
            .opacity(0.8)
            .multilineTextAlignment(.leading)
            .padding()
            .background{
              Rectangle()
                .foregroundColor(.yellow.opacity(0.7))
            }
        }
      }.padding()
    }
    .navigationTitle("From \(post.wrappedPost.account.displayName ?? "--")")
    .background{
      Image("wood-texture").resizable().edgesIgnoringSafeArea(.all)
    }
  }
}

