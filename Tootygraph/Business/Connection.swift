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
    var feeds: [any Feed] = []
    
    var homeFeed: TootFeed? = nil
    var notificationsFeed: NotificationsFeed? = nil
    
    var settings: SettingsManager
    
    let id: UUID = UUID()
    
    private(set) var tootClient: TootClient?

    
    init(account: FediAccount, settings: SettingsManager = SettingsManager()) {
        self.settings = settings
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
            let serverAccount = account
            let userAccount = try await client.verifyCredentials()
            serverAccount.userAccount = userAccount
            serverAccount.avatarURL = URL(string: userAccount.avatar)
            self.tootClient = client
            connectionState = .connected
            homeFeed = TootFeed(client: client,
                                timeline: .home,
                                palette: palette,
                                accountNiceName: serverAccount.niceName,
                                settings: settings)
            notificationsFeed = NotificationsFeed(client: client, settings: settings)
            
        } catch {
            connectionState = .error(error: error)
        }

    }
    
    enum ConnectionState {
        case connecting
        case error(error: Error)
        case connected
    }
    
    enum ConnectionError: Error {
        case notConnected
    }
    
    func hasFeed(_ feed: any Feed) -> Bool {
        return feeds.contains{ $0.id == feed.id }
    }
    
    func feedFor(_ account: Account) -> (any Feed)? {
        guard let tootClient else { return nil }
        let timeline = Timeline.user(userID: account.id)
        let feed = TootFeed(client: tootClient, timeline: timeline, palette: palette, accountNiceName: account.acct, settings: settings)
        return feed
    }

}


extension Connection: Identifiable {
    
}

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
