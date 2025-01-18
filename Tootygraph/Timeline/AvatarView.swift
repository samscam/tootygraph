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
    let booster: Account?
    
    init(account: Account, booster: Account? = nil) {
        self.account = account
        self.booster = booster
    }
    
  var body: some View{
          HStack(alignment:.top){
              AvatarImage(url: URL(string:account.avatar))
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
              
              if let booster {
                  Spacer()
                  AvatarImage(url: URL(string:booster.avatar))
                      .frame(width:40,height:40)
              }
          }
          
          
  }
}

struct AvatarImage: View {
    let url: URL?
    var body: some View{
        LazyImage(url: url){ state in
            if let image = state.image {
                image
                    .avatarStyle()
                    
            } else {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
    
}

extension Image {

    func avatarStyle() -> some View {
        return self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(2)
            .background{
                RoundedRectangle(cornerRadius: 6).fill( Color.secondary)
            }
    }
    
    
}

extension View {
    func hearty() -> some View {
        return self
            .mask(
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            )
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
