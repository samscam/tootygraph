//
//  MainView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import SwiftUI

enum MainViewStates {
  case noAccounts
  case normal
}

struct MainView: View {

  
  @StateObject var settings = Settings()
  @StateObject var accountsManager = AccountsManager()
  
  @State var status: MainViewStates = .noAccounts

  var body: some View {
    if let client = accountsManager.selectedClient {
      NavigationStack{
        TimelineView(client: client)
          .background{
            Image("wood-texture").resizable().edgesIgnoringSafeArea(.all)
          }
          .environmentObject(settings)
          .environmentObject(accountsManager)
          .toolbar {
            Button {
              accountsManager.signOut()
            } label: {
              Image(systemName: "figure.socialdance")
                .resizable()
                .frame(width: 40, height: 40)
              
            }
          }
      }
    } else {
      AccountsView()
        .environmentObject(settings)
        .environmentObject(accountsManager)
    }

  }
}
