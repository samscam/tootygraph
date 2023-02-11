//
//  AvatarView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 05/02/2023.
//

import SwiftUI
import NukeUI

struct AvatarView: View {
  let account: Account
  
  var body: some View{

    HStack(alignment:.center){
      LazyImage(url: account.avatar){ state in
        if let image = state.image {
          image
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .opacity(0.8)
        } else {
          Rectangle().foregroundColor(.gray.opacity(0.3))
        }
      }
      .frame(width:40,height:40)
      
      VStack(alignment: .leading){
        Text(account.displayName)
          .bold()
          .lineSpacing(-3)
          .foregroundColor(.black)
        Text(account.acct)
          .font(.caption)
          .foregroundColor(.black)
      }.opacity(0.6)
      
    }
    .padding(EdgeInsets(top: 9, leading: 35, bottom: 7, trailing: 75))
    .background(
      Image("masking-tape")
        .resizable()
    )
    
  }
}

struct AvatarView_Previews: PreviewProvider {
  
  
  static let accounts = [
    Account(id:"432",
            username: "sam",
            acct: "sam@togl.me",
            displayName: "Sam Easterby-Smith",
            avatar: Bundle.main.url(forResource: "sam", withExtension: "jpeg")),
    Account(id:"1234",
            username: "sarah",
            acct: "sarah@togl.me",
            displayName: "Sarah",
            avatar: Bundle.main.url(forResource: "sarah", withExtension: "jpeg"))
    ]
  static var previews: some View {
    VStack{
      ForEach(accounts) { account in
        AvatarView(account: account)
      }
    }
  }
}

public extension Color {

    #if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
    #else
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    #endif
}
