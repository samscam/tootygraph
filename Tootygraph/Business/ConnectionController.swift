//
//  Connection.swift
//  Tootygraph
//
//  Created by Sam on 17/01/2024.
//

import Foundation
import TootSDK

/**
The ConnectionController is responsible for a single connection to a fedi account.
 
*/
@MainActor
class ConnectionController: ObservableObject {
    
    @Published var connectionState: ConnectionState = .connecting
    @Published var account: FediAccount
    @Published var timelines: [TimelineController] = []
    
    @Published private (set) var tootClient: TootClient?

    
    init(account: FediAccount) {
        self.account = account
    }
    
    var avatarURL: URL? {
        guard let avatar = account.userAccount?.avatar else {
            return nil
        }
        return URL(string:avatar)
    }
    
    var headerURL: URL? {
        guard let header = account.userAccount?.header else {
            return nil
        }
        return URL(string:header)
    }
    
    var palette: Palette {
        return Palette(account.hue)
    }
    
    func connect() async throws {
        guard tootClient == nil else {
            return
        }
        connectionState = .connecting
        do {
            let client = try await TootClient(connect: account.instanceURL, clientName:"Tootygraph", accessToken: account.accessToken)
            
            // We need to refresh the server account with the user account
            var serverAccount = account
            let userAccount = try await client.verifyCredentials()
            serverAccount.userAccount = userAccount
            self.tootClient = client
            connectionState = .connected
            
            timelines = [
                TimelineController(client: client, timeline: .home),
                TimelineController(client: client, timeline: .federated)
            ]
        } catch {
            connectionState = .error(error: error)
        }

    }
    
    enum ConnectionState {
        case connecting
        case error(error: Error)
        case connected
    }
    
    
}


extension ConnectionController: Identifiable {}

extension ConnectionController: Hashable{
    nonisolated func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

extension ConnectionController: Equatable {
    nonisolated static func == (lhs: ConnectionController, rhs: ConnectionController) -> Bool {
      lhs.id == rhs.id
    }
}
