//
//  Connection.swift
//  Tootygraph
//
//  Created by Sam on 17/01/2024.
//

import Foundation
import TootSDK

/**
The Connection is responsible for a single connection to a fedi account.
 
*/
@MainActor
@Observable
class Connection {
    
    var connectionState: ConnectionState = .connecting
    var account: FediAccount
    var timelines: [TimelineController] = []
    
    private (set) var tootClient: TootClient?

    
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
                TimelineController(client: client,
                                   timeline: .home,
                                   palette: palette,
                                   accountNiceName: serverAccount.niceName),
                TimelineController(client: client,
                                   timeline: .federated,
                                   palette: palette,
                                  accountNiceName: serverAccount.niceName)
            ]
        } catch {
            connectionState = .error(error: error)
        }

    }
    func timeline(_ timelineType: Timeline) throws -> TimelineController{
        guard let tootClient else {
            throw ConnectionError.notConnected
        }
        return TimelineController(client: tootClient,
                           timeline: .federated,
                           palette: palette,
                                  accountNiceName:account.niceName)
    }
    
    enum ConnectionState {
        case connecting
        case error(error: Error)
        case connected
    }
    
    enum ConnectionError: Error {
        case notConnected
    }
    
    
}


extension Connection: Identifiable {}

extension Connection: Hashable{
    nonisolated func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

extension Connection: Equatable {
    nonisolated static func == (lhs: Connection, rhs: Connection) -> Bool {
      lhs.id == rhs.id
    }
}
