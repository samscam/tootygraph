//
//  ServerAccountView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import SwiftUI
import NukeUI

struct ServerAccountView: View{
    
    @Binding var account: ServerAccount
    
    var body: some View {
        HStack{
            
            if let avatarURL = account.userAccount?.avatar {
                LazyImage(url: URL(string:avatarURL)) { state in
                    if let image = state.image {
                        image
                            .resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Color.red
                    }
                }
                .frame(width:80,height:80)
            } else {
                Image(systemName: "person")
                    .resizable()
                    .frame(width:80,height:80)
            }
            
            VStack(alignment: .leading){
                Text("@\(account.username)").font(.title3)
                if let host = account.instanceURL.host {
                    Text(host)
                }
            }.padding(5)
            ColorPicker("Colour", selection: $account.color.cgColor)
        }
        .border(Color(cgColor: account.color.cgColor), width:3)
        .padding(5)
    }
}
