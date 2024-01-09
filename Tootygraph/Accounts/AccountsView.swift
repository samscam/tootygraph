//
//  AccountsView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import SwiftUI


struct AccountsView: View {
  @EnvironmentObject var accountsManager: AccountsManager
  

  var body: some View {
    ScrollView{
      if (accountsManager.accounts.count > 0){
        Text("Accounts").font(.title)
        
        ForEach($accountsManager.connections){ $connection in
            ServerAccountView(account:$connection.serverAccount)
                
          
        }
        
        
      } else {
          Group{
              Text("Welcome to Tootygraph").font(.title)
              Spacer()
              Text("Add a fedi account to get started")
              
          }.multilineTextAlignment(.center)
      }
      
        Spacer()
        Divider()
        AddServerView()

        Spacer()
        Divider()
        SettingsMenu()
    }.padding()
  }
}
struct AddServerView: View {
    
    @EnvironmentObject var accountsManager: AccountsManager
    
    @State var newAccountURLString: String = ""
    
    var body: some View {
        Group{
            Text("Add a server").font(.title)
            Text("Tootygraph supports Mastodon, Pixelfed, and probably others")
        }.multilineTextAlignment(.center)
        
      TextField("https://your.server", text: $newAccountURLString)
            .font(.title2)
            .autocorrectionDisabled(true)
            .textContentType(.URL)
            .textInputAutocapitalization(.never)
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
    }
}
struct AccountsView_Previews: PreviewProvider {
  static let accountsManager = {
    let accountsManager = AccountsManager()
//    let ac1 = ServerAccount(id: "1234", username: "foo", instanceURL: URL(string: "https://example.com")!,  accessToken: nil, userAccount: nil)
//    accountsManager.accounts.append(ac1)
    return accountsManager
    
  }()
    static var previews: some View {
      AccountsView().environmentObject(accountsManager)
    }
}
