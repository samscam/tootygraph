//
//  AccountsViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/02/2023.
//

import Foundation
import TootSDK
import SwiftData

enum AccountsManagerError: Error {
    case invalidURL
    case alreadyConnected
}


/**
 The AccountsManager is responsible for managing the different fedi accounts that the user has added to the app.
 */
@MainActor
@Observable
class AccountsManager {
    
    @ObservationIgnored let modelContainer: ModelContainer
    
    var loadState: LoadState = .starting
    var connections: [Connection] = []
    
    init(modelContainer: ModelContainer){
        self.modelContainer = modelContainer
        Task{
            try await connectAll()
        }
    }
    
    func recoverAction() {

    }
    
    func connectAll() async throws {
        
        let fetch = try modelContainer.mainContext.fetch(FetchDescriptor<FediAccount>())
        connections = fetch.map{
            Connection(account: $0)
        }
        for connection in connections {
            loadState = .message(message: "connecting to \(connection.account.niceName)")
            try await connection.connect()
        }
        loadState = .loaded
    }
    
    func addServerAccount(_ account: FediAccount) async throws{
        let context = modelContainer.mainContext
        context.insert(account)
        Task{
            try await connectAll()
        }
    }
    
    func deleteServerAccount(_ account: FediAccount) async throws{
        let context = modelContainer.mainContext
        context.delete(account)
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
        try modelContainer.mainContext.delete(model: FediAccount.self)
    }
    
    subscript(id: UUID) -> Connection?{
        return connections.first{
            id == $0.id
        }
    }
    
    func feed(id: UUID) -> (any Feed)? {
        let allFeeds = connections.flatMap{$0.feeds}
        return allFeeds.first { $0.id == id }
    }
    
    func connectionContaining(feedID: UUID) -> Connection? {
        connections.first { connection in
            connection.feeds.contains { inFeed in
                inFeed.id == feedID
            }
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

