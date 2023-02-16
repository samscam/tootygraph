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
  
  var post: PostWrapper
  let onSelected: ((PostWrapper, Attachment)->Void)?

  let photoNamespace: Namespace.ID
  let accountNamespace: Namespace.ID
  let geometry: GeometryProxy
  
  var body: some View{
    VStack(alignment: .center, spacing: 0) {
      
      AvatarView(account: post.wrappedPost.account).zIndex(5).padding(.bottom, -10)
        .rotationEffect(Angle(degrees: settings.jaunty ? post.jauntyAngles[0] : 0 ) )
//        .matchedGeometryEffect(id: post.wrappedPost.account.id, in: accountNamespace)
      
      ForEach(post.wrappedPost.mediaAttachments){ media in
        let index = post.wrappedPost.mediaAttachments.firstIndex(of: media)!
        let jaunty = post.jauntyAngles[index+1]
        
        VStack(alignment: .center,spacing: 0){
          
          NavigationLink {
            DetailView(post: post, selectedMedia: media, photoNamespace: photoNamespace, accountNamespace: accountNamespace)
          } label: {
            PhotoFrame(media: media)

//              .matchedGeometryEffect(id: media.id, in: photoNamespace)

          }.buttonStyle(.plain)
          
        }
          .rotationEffect(Angle(degrees: settings.jaunty ? jaunty : 0))
          .frame(maxWidth: geometry.size.width * 0.9)
          .frame(maxHeight: geometry.size.height * 0.8)
        
        
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
