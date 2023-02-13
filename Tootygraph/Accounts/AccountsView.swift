//
//  AccountsView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import SwiftUI

struct AccountsView: View {
  @EnvironmentObject var accountsManager: AccountsManager
  
  @State var newAccountURLString: String = ""
  
  var body: some View {
    ScrollView{
      if (accountsManager.accounts.count > 0){
          Text("Accounts")
            
            VStack{
          ForEach(accountsManager.accounts){ account in
            Button {
              Task{
                do {
                  try await accountsManager.connect(account)
                } catch {
                  print("failed to connect \(error)")
                }
              }
            } label: {
              ServerAccountView(account:account)
            }

            
          }
        }
        Spacer()
        Divider()
      }
      

      Text("Add a server")
      TextField("URL", text: $newAccountURLString).font(.title)
        .padding()
        
        .border(Color.accentColor, width: 3)
        
      Button {
        Task{
          try? await accountsManager.startAuth(urlString: newAccountURLString)
        }
      } label: {
        Text("Authenticate")
      }

    }.padding()
  }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
