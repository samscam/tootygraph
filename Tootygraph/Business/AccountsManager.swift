//
//  AccountsViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import Foundation
import TootSDK
import Boutique

import NukeUI
import Nuke
import NukeVideo


enum AccountsManagerError: Error {
    case invalidURL
    case alreadyConnected
}


/**
 The AccountsManager is responsible for managing the different fedi accounts that the user has added to the app.
 
 
 */
@MainActor
class AccountsManager: ObservableObject {
    
    // Nope we can't be having this... credentials need to be in the keychain
    @Stored(in: .serverAccountsStore) private var accounts: [FediAccount]
    
    @Published var connections: [ConnectionManager] = []
    
    init(){
        // This is to make Nuke be able to handle videos, apparently
        ImageDecoderRegistry.shared.register(ImageDecoders.Video.init)
        
        $accounts.$items
            .map{ serverAccounts in
                serverAccounts.map { serverAccount in
                    let conn = ConnectionManager(account: serverAccount)
                    Task{
                        try await conn.connect()
                    }
                    return conn
                }
            }
            .assign(to: &$connections)
    }
    
    func connectAll() async throws {
        for connection in connections {
            try await connection.connect()
        }
    }
    
    func addServerAccount(_ account: FediAccount) async throws{
        try await $accounts.insert(account)
    }
    
    func removeServerAccount(_ account: FediAccount) async throws{
        try await $accounts.remove(account)
    }
    
    
    func startAuth(urlString: String) async throws {
        var urlString = urlString
        
        // make sure we have a scheme on the url
        if !urlString.starts(with: "https://") {
            urlString = "https://"+urlString
        }
        
        guard let url = URL(string: urlString) else {
            throw AccountsManagerError.invalidURL
        }
        
        let client = try await TootClient(connect: url)
        
        let accessToken = try await client.presentSignIn(callbackURI: "tootygraph://auth")
        let userAccount = try await client.verifyCredentials()
        
        let serverAccount = FediAccount(id: userAccount.id,
                                        username: userAccount.acct,
                                          hue: .random(in: 0...1) , instanceURL: url, accessToken: accessToken, userAccount: userAccount)
        try await addServerAccount(serverAccount)
        
    }
    
    func reset() async throws{
        for connection in connections {
            try await removeServerAccount(connection.account)
        }
    }
    
    subscript(accountId:String) -> ConnectionManager?{
        return connections.first{
            accountId == $0.account.id
        }
    }
}

