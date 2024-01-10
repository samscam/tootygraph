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
                            Color.red
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
            }.padding(5).foregroundColor(.white)
            Spacer()
            ColorPicker("Colour", selection: $account.color.cgColor).labelsHidden()
                .padding(.trailing,10)
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
                            .opacity(0.6)
                            
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(1)
        .background(Color(cgColor: account.color.cgColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
#Preview(traits: .sizeThatFitsLayout){
    @State var account: ServerAccount = ServerAccount(
        id: "someid",
        username: "sam",
        color: .random(),
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
