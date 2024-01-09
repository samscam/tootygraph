//
//  AccountsViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import Foundation
import TootSDK
import Boutique

enum AccountCreationError: Error {
    case invalidURL
}

@MainActor
class Connection: Identifiable, ObservableObject {
    @Published var serverAccount: ServerAccount
    @Published var tootClient: TootClient?
    
    init(serverAccount: ServerAccount) {
        self.serverAccount = serverAccount
    }
    
    func connect() async throws {
        guard tootClient == nil else {
            return
        }
        
        let client = try await TootClient(connect: serverAccount.instanceURL, accessToken: serverAccount.accessToken)
        
        // We need to refresh the server account with the user account
        var serverAccount = serverAccount
        let userAccount = try await client.verifyCredentials()
        serverAccount.userAccount = userAccount
        
        self.tootClient = client
        
    }
}

@MainActor
protocol AccountsManagerProtocol: ObservableObject {
    var connections: [Connection] { get }
    
    func addServerAccount(_ serverAccount: ServerAccount) async throws
    func removeServerAccount(_ serverAccount: ServerAccount) async throws
    func connect(_ serverAccount: ServerAccount) async throws
    func startAuth(urlString: String) async throws
    func signOut()
}


@MainActor
class AccountsManager: AccountsManagerProtocol {
    // Nope we can't be having this... credentials need to be in the keychain
    @Stored(in: .serverAccountsStore) var accounts: [ServerAccount]
    
    @Published var connections: [Connection] = []
    
    init(){
        $accounts.$items
            .map{ serverAccounts in
                serverAccounts.map { serverAccount in
                    Connection(serverAccount: serverAccount)
                }
            }
            .assign(to: &$connections)
    }
    
    func connectAll() async throws {
        for connection in connections {
            try await connection.connect()
        }
    }
    
    func addServerAccount(_ serverAccount: ServerAccount) async throws{
        try await $accounts.insert(serverAccount)
    }
    
    func removeServerAccount(_ serverAccount: ServerAccount) async throws{
        try await $accounts.remove(serverAccount)
    }
    
    func connect(_ serverAccount: ServerAccount) async throws {
        
        // check if we already have a connected client
        
        
        let client = try await TootClient(connect: serverAccount.instanceURL, accessToken: serverAccount.accessToken)
        
        // We need to refresh the server account with the user account
        var serverAccount = serverAccount
        let userAccount = try await client.verifyCredentials()
        serverAccount.userAccount = userAccount
        try await addServerAccount(serverAccount)
        
        
    }
    
    func startAuth(urlString: String) async throws {
        var urlString = urlString
        
        // make sure we have a scheme on the url
        if !urlString.starts(with: "https://") {
            urlString = "https://"+urlString
        }
        
        guard let url = URL(string: urlString) else {
            throw AccountCreationError.invalidURL
        }
        
        let client = try await TootClient(connect: url)
        
        let accessToken = try await client.presentSignIn(callbackURI: "tootygraph://auth")
        let userAccount = try await client.verifyCredentials()
        
        let serverAccount = ServerAccount(id: userAccount.id, username: userAccount.acct,
                                          color: .random() , instanceURL: url, accessToken: accessToken, userAccount: userAccount)
        try await addServerAccount(serverAccount)
        
        
        
    }
    
    func signOut(){
        //    selectedClient = nil
    }
    
    
}

