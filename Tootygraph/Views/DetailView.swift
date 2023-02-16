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
        if let parsedContent = post.attributedContent {
          Text(parsedContent)
            .font(.system(.callout, design: .rounded))
            .multilineTextAlignment(.leading)
            .padding()
            .background{
              RoundedRectangle(cornerRadius: 20).foregroundColor(.gray.opacity(0.2))
            }
        }
        ForEach(post.wrappedPost.mediaAttachments) { media in
          
            PhotoFrame(media: media)
//              .matchedGeometryEffect(id: media.id, in: photoNamespace)
          
          Spacer(minLength: 40)

        }
      }.padding()
    }
    .navigationTitle("From \(post.wrappedPost.account.displayName ?? "--")")
    .background{
      Image("wood-texture").resizable().edgesIgnoringSafeArea(.all)
    }
  }
}

