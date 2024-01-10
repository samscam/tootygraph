//
//  AccountsView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import SwiftUI
import TootSDK

struct AccountsView: View {
    @EnvironmentObject var accountsManager: AccountsManager
    @FocusState var fieldFocussed: Bool
    @Binding var selectedViewTag: String
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                Image("greenicon1024")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .photoFrame()
                    .frame(width:128)
                if (accountsManager.accounts.count > 0){
                    Text("Accounts").font(.title)
                    
                    ForEach($accountsManager.connections){ $connection in
                        ServerAccountView(account:$connection.serverAccount)
                            .onTapGesture {
                                
                                selectedViewTag = connection.serverAccount.niceName
                            }
                        
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
                AddServerView(fieldFocussed: $fieldFocussed)
                
                Spacer()
                Divider()
                SettingsMenu()
                Spacer()
                Divider()
                Button("Reset") {
                    Task{
                        try await accountsManager.reset()
                    }
                }
            }.padding()
            .onTapGesture {
                fieldFocussed = false
            }
            
        }
    }
}

#Preview{
    
    @State var account: ServerAccount = ServerAccount(
        id: "someid",
        username: "sam",
        color: .random(),
        instanceURL: URL(string: "https://togl.me")!,
        accessToken: nil,
        userAccount: Account(
            id: "arrg",
            acct: "dunno",
            url: "https://example.foo",
            note: "no notes",
            avatar: "https://togl.me/system/accounts/avatars/109/331/181/925/532/108/original/4f663b6f6802cac5.jpeg",
            header: "https://togl.me/system/accounts/headers/109/331/181/925/532/108/original/cc4bcf8745fae566.jpg",
            headerStatic: "static",
            locked: false,
            emojis: [],
            createdAt: Date(),
            postsCount: 1023,
            followersCount: 123,
            followingCount: 432,
            fields: []))
    
    @StateObject var accountsManager = AccountsManager()
    @StateObject var settings = Settings()
    @State var selectedViewTag: String = "settings"
    
    return AccountsView(selectedViewTag: $selectedViewTag)
        .environmentObject(accountsManager)
        .environmentObject(settings)
        .onAppear{
            Task{
                try await accountsManager.addServerAccount(account)
                
            }
        }
}
