//
//  AccountsViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import Foundation
import TootSDK
import Boutique


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
    
    @Published var loadState: LoadState = .starting
    @Published var connections: [Connection] = []
    
    init(){
        
        
        $accounts.$items
            .map{ serverAccounts in
                serverAccounts.map { serverAccount in
                    let conn = Connection(account: serverAccount)
                    Task{
                        try await conn.connect()
                    }
                    return conn
                }
            }
            .assign(to: &$connections)
        
        Task{
            do{
                try await $accounts.itemsHaveLoaded()
                
                loadState = .loaded
                
            } catch {
                loadState = .error(error: error)
                print(error)
            }
        }
    }
    
    func recoverAction() {
        Task {
            do {
                try await Store.serverAccountsStore.removeAll()
                
            } catch {
                self.loadState = .error(error: error)
            }
        }
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
        
        let client = try await TootClient( connect: url,clientName:"Tootygraph")
        
        
        let accessToken = try await client.presentSignIn(callbackURI: "tootygraph://auth")
        let userAccount = try await client.verifyCredentials()
        
        let serverAccount = FediAccount(id: userAccount.id,
                                        username: userAccount.acct,
                                        hue: .random(in: 0...1),
                                        instanceURL: url,
                                        accessToken: accessToken,
                                        userAccount: userAccount)
        try await addServerAccount(serverAccount)
        
    }
    
    func reset() async throws{
        for connection in connections {
            try await removeServerAccount(connection.account)
        }
    }
    
    subscript(id: UUID) -> Connection?{
        return connections.first{
            id == $0.id
        }
    }
    
    enum LoadState: Equatable {
        static func == (lhs: AccountsManager.LoadState, rhs: AccountsManager.LoadState) -> Bool {
            switch (lhs,rhs) {
            case (.starting,.starting):
                return true
            case (.message(let lmessage), .message(let rmessage)):
                return lmessage == rmessage
            case (.error(let lerr),.error(let rerr)):
                return lerr.localizedDescription == rerr.localizedDescription
            case (.loaded,.loaded):
                return true
            default:
                return false
            }
        }
        
        case starting
        case message(message: String)
        case error(error: Error)
        case loaded
    }
}

