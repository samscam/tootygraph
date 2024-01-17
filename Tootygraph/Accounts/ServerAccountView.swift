//
//  ServerAccountView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import SwiftUI
import NukeUI
import TootSDK

struct ServerAccountView: View{
    @Environment(\.palette) var palette: Palette
    
    @Binding var account: ServerAccount
    
    var body: some View {
        HStack{
            Group{
                if let avatarURL = account.userAccount?.avatar {
                    LazyImage(url: URL(string:avatarURL)) { state in
                        if let image = state.image {
                            image
                                .resizable().aspectRatio(contentMode: .fill)
                        } else {
                            Color.gray
                        }
                    }
                    
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .padding(10)
                        .background()
                        
                }
            }
            .frame(width:80,height:80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading){
                Text("@\(account.username)").font(.title3).bold()
                Text(account.host)
            }.padding(5).foregroundColor(.primary)
            Spacer()
        }

        .padding(5)
        .background{
            if let headerURL = account.userAccount?.header {
                LazyImage(url: URL(string:headerURL)) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 2)
                            .saturation(0)
                            .opacity(0.3)
                            
                            
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .background(palette.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay{
            RoundedRectangle(cornerRadius: 10)
                .stroke(palette.highlight,lineWidth: 3)
        }
        
    }
}
#Preview(traits: .sizeThatFitsLayout){
    @State var account: ServerAccount = ServerAccount(
        id: "someid",
        username: "sam",
        hue: .random(in: 0...1),
        instanceURL: URL(string: "https://togl.me")!,
        accessToken: nil,
        userAccount: Account(
            id: "arrg",
            acct: "dunno",
            url: "https://example.foo",
            note: "no notes",
            avatar: "https://togl.me/system/accounts/avatars/109/331/181/925/532/108/original/4f663b6f6802cac5.jpeg",
            header: "https://togl.me/system/accounts/headers/109/331/181/925/532/108/original/cc4bcf8745fae566.jpg",
            headerStatic: "static",
            locked: false,
            emojis: [],
            createdAt: Date(),
            postsCount: 1023,
            followersCount: 123,
            followingCount: 432,
            fields: []))
    return ServerAccountView(account: $account).padding()
}
