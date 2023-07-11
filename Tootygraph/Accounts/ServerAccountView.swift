//
//  ServerAccountView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import SwiftUI
import NukeUI

struct ServerAccountView: View{
  let account: ServerAccount
  var body: some View {
    HStack{
      
      if let avatarURL = account.userAccount?.avatar {
        LazyImage(url: URL(string:avatarURL))
          .frame(width:80,height:80)
      } else {
        Image(systemName: "person")
          .resizable()
          .frame(width:80,height:80)
      }
        
      VStack(alignment: .leading){
        Text("@\(account.username)").font(.title3)
        Text(account.instanceURL.absoluteString)
      }
    }.padding(10)
      .border(Color.accentColor, width:3)
      .padding(5)
  }
}
