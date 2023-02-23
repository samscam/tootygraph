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
  let geometry: GeometryProxy
  
  var body: some View{
    ZStack {
      NavigationLink {
        DetailView(post: post, selectedMedia: nil)
      } label: {
        EmptyView()
      }.buttonStyle(.plain).opacity(0)
      
      VStack(alignment: .center, spacing: 0) {
        
        AvatarView(account: post.wrappedPost.account)
          .rotationEffect(Angle(degrees: settings.jaunty ? post.jauntyAngles[0] : 0 ) )
        
        ForEach(post.wrappedPost.mediaAttachments){ media in
          let index = post.wrappedPost.mediaAttachments.firstIndex(of: media)!
          let jaunty = post.jauntyAngles[index+1]
          
          PhotoView(media: media)
            .rotationEffect(Angle(degrees: settings.jaunty ? jaunty : 0))
          
          // These are currently commented out - because they mess up other aspects of
          // scaling the photo frames... :/
          // .frame(maxWidth: geometry.size.width * 0.9)
          // .frame(maxHeight: geometry.size.height * 0.9)
          
        }
        Spacer(minLength: 10)
        
        ActionsView(actions: [.boost,.reply,.favourite,.share])
          .frame(maxWidth: .infinity)
        
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
