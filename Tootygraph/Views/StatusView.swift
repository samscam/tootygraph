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
  
  let post: PostWrapper
  let onSelected: ((PostWrapper, Attachment)->Void)?
  
  let photoNamespace: Namespace.ID

  
  var body: some View{
    VStack(alignment: .center, spacing: 0) {
      
      AvatarView(account: post.wrappedPost.account).zIndex(5).padding(.bottom, -10)
        .rotationEffect(Angle(degrees: settings.jaunty ? Double.random(in: -5...5) : 0 ) )
      
      ForEach(post.wrappedPost.mediaAttachments){ media in
        
        VStack(alignment: .center,spacing: 0){
          
          NavigationLink {
            DetailView(post: post, selectedMedia: media, photoNamespace: photoNamespace)
          } label: {
            PhotoFrame(media: media)
//              .matchedGeometryEffect(id: media.id, in: photoNamespace)

          }
        }
        .rotationEffect(Angle(degrees: settings.jaunty ? Double.random(in: -3...3) : 0))
        
        
      }.padding(.bottom,20)
    }
  }
  
}

//struct StatusView_Previews: PreviewProvider {
//  @Namespace var fake
//  static var previews: some View {
//    let status = Status(id: "123", createdAt: Date(), mediaAttachments: [], account: Account.init(id:
//                                                                                                    "432", username: "lovely",acct: "lovely@tooty.com", displayName: "Someone Lovely", avatar: URL(string: "https://togl.me/system/cache/accounts/avatars/109/333/607/768/620/174/original/0b6f3e0b890b1811.jpg")), content: "Foo")
//    StatusView(status: status, photoNamespace: fake)
//  }
//}
