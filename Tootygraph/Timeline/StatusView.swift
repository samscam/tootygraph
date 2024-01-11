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
  let geometry: GeometryProxy
  
  var body: some View{
    ZStack {
      NavigationLink {
        DetailView(post: post, selectedMedia: nil).environmentObject(settings)
      } label: {
        EmptyView()
      }.buttonStyle(.plain).opacity(0)
      
      VStack(alignment: .center, spacing: 0) {
        
        AvatarView(account: post.displayPost.account)
          .rotationEffect(Angle(degrees: settings.jaunty ? post.jauntyAngles[0] : 0 ) )
        
        Spacer()
        
        ForEach(post.mediaAttachments){ media in
            
          let index = post.mediaAttachments.firstIndex(of: media)!
          let jaunty = post.jauntyAngles[index+2]
          
            VStack{
                
                switch media.type {

                case .video:
                    Text("Whoops video")
                case .gifv:
                    Text("Whoops Gif")
                case .audio:
                    Text("Whoops audio")
                case .image:
                    EmptyView()
                case .unknown:
                    Text("UNKNOWN")
                    
                }
                PhotoView(media: media)
                
            }
            .rotationEffect(Angle(degrees: settings.jaunty ? jaunty : 0))
          // These are currently commented out - because they mess up other aspects of
          // scaling the photo frames... :/
//           .frame(maxWidth: geometry.size.width * 0.9)
//           .frame(maxHeight: geometry.size.height * 0.9)
          
          if !settings.jaunty || index == post.mediaAttachments.count-1{
            Spacer()
          }
          
        }
        
        if settings.showContent{
          let parsedContent = post.attributedContent
          Text(parsedContent)
            .font(.custom("AmericanTypewriter",size:24))
            .foregroundColor(.black)
            .opacity(0.8)
            .multilineTextAlignment(.leading)
            .layoutPriority(10)
            .padding()
            .background{
              Rectangle()
                .foregroundColor(.yellow.opacity(0.7))
            }
            .rotationEffect(Angle(degrees: settings.jaunty ? post.jauntyAngles[1] : 0))
        }
        Spacer()
        HStack(spacing:20){
          ActionButtonView(highlighted: post.displayPost.favourited ?? false, actionType: .favourite) {
            Task{
                try await post.toggleFavourite()
            }
          }.frame(width:50,height:50)
          ActionButtonView(highlighted: post.displayPost.reposted ?? false, actionType: .boost) {
            Task{
              try await post.toggleBoost()
            }
          }.frame(width:50,height:50)
        }

          .rotationEffect(Angle(degrees: settings.jaunty ? post.jauntyAngles[2] : 0))
        
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
