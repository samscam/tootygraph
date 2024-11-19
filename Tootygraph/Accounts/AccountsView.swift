//
//  AccountsView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import SwiftUI
import TootSDK

struct AccountsView: View {
    
    @Environment(AccountsManager.self) var accountsManager: AccountsManager
    
    @FocusState var fieldFocussed: Bool
    
    @State private var showResetAlert: Bool = false
    
    var body: some View {
        ScrollView{
            VStack(alignment:.center){
                Image("greenicon1024")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .photoFrame()
                    .frame(width:128)
                    .padding(.top,20)
            }
            VStack(alignment:.leading){
                if (accountsManager.connections.count > 0){
                    Text("Accounts").font(.title)
                    
                    ForEach(accountsManager.connections){ connection in
                        ServerAccountView(connection:connection)
                            .palette(connection.palette)
                            .frame(maxWidth: .infinity)
                            
                            .contentShape(Rectangle())
                        
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
                SettingsMenuView()
                Spacer()
                Divider()
                Button("Reset") {
                    showResetAlert = true
                }.alert("Are you sure you want to reset Tootygraph?",isPresented: $showResetAlert){
                    Button("Reset",role:.destructive){
                        Task {
                            try await accountsManager.reset()
                        }
                    }
                    Button("Cancel",role: .cancel){
                        
                    }
                }
                    
            }.padding()
            .contentShape(Rectangle())
            .onTapGesture {
                fieldFocussed = false
            }
            
        }.scrollDismissesKeyboard(.automatic)
    }
}

#Preview{
    @Namespace var fakeNamespace
    @State var account: FediAccount = FediAccount(
        id: "someid",
        username: "sam",
        hue: .random(in: 0...1),
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
    
    @State var accountsManager = AccountsManager()
    
    @StateObject var settings = SettingsManager()
    @FocusState var fieldFocussed: Bool
    
    AccountsView()
        .environment(accountsManager)
        .environmentObject(settings)
        .onAppear{
            Task{
                try await accountsManager.addServerAccount(account)
                
            }
        }
}
