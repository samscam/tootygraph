//
//  AvatarView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 05/02/2023.
//

import SwiftUI
import NukeUI
import TootSDK

struct AvatarView: View {
  let account: Account
  
  var body: some View{
          HStack(alignment:.top){
              LazyImage(url: URL(string:account.avatar)){ state in
                  if let image = state.image {
                      image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .clipShape(RoundedRectangle(cornerRadius: 5))
                          
                  } else {
                      Rectangle().foregroundColor(.gray.opacity(0.3))
                  }
              }
              .frame(width:40,height:40)
              
              VStack(alignment: .leading){
                  Text(account.displayName ?? "--")
                      .font(.headline)
                      .lineSpacing(-3)
                      .foregroundColor(.primary)
                  Text(account.acct)
                      .font(.caption)
                      .foregroundColor(.secondary)
              }
          }
          
          
  }
}

#if DEBUG
#Preview(traits:.sizeThatFitsLayout) {
    AvatarView(account: TestAccounts.alpaca)
}


#Preview(traits:.sizeThatFitsLayout) {
    AvatarView(account: TestAccounts.sam)
}
#endif
