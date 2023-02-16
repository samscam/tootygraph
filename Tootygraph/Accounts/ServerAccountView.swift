//
//  ServerAccountView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import SwiftUI

struct ServerAccountView: View{
  let account: ServerAccount
  var body: some View {
    HStack{
      Text(account.username)
      Text(account.instanceURL.absoluteString)
      
    }.padding(10)
      .border(Color.accentColor, width:3)
      .padding(5)
  }
}
