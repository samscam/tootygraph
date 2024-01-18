//
//  Connection.swift
//  Tootygraph
//
//  Created by Sam on 17/01/2024.
//

import Foundation
import TootSDK

/**
The ConnectionManager is responsible for a single connection to a fedi account.
 
*/
@MainActor
class ConnectionManager: Identifiable, ObservableObject {
    @Published var account: FediAccount
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
        
        let client = try await TootClient(connect: account.instanceURL, accessToken: account.accessToken)
        
        // We need to refresh the server account with the user account
        var serverAccount = account
        let userAccount = try await client.verifyCredentials()
        serverAccount.userAccount = userAccount
        
        self.tootClient = client
        
    }
}

