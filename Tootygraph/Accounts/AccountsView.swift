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
        Text("Accounts").font(.title)
        
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
          }.buttonStyle(.plain)
        }
        
        Spacer()
        Divider()
      }
      

      Text("Add a server").font(.title)
      TextField("https://your.server", text: $newAccountURLString).font(.title2)
        .multilineTextAlignment(.center)
        .padding()
        
        .border(Color.accentColor, width: 1)
      
      Button {
        Task{
          try? await accountsManager.startAuth(urlString: newAccountURLString)
        }
      } label: {
        Text("Authenticate")
      }.buttonStyle(.borderedProminent)

    }.padding()
  }
}

//struct AccountsView_Previews: PreviewProvider {
//  static let accountsManager = {
//    let accountsManager = MockAccountsManager()
//    let ac1 = ServerAccount(id: "1234", username: "foo", instanceURL: URL(string: "https://example.com")!,  accessToken: nil, userAccount: nil)
//    accountsManager.accounts.append(ac1)
//    return accountsManager
//    
//  }()
//    static var previews: some View {
//      AccountsView().environmentObject(accountsManager)
//    }
//}
