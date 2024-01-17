//
//  Connection.swift
//  Tootygraph
//
//  Created by Sam on 17/01/2024.
//

import Foundation
import TootSDK

@MainActor
class Connection: Identifiable, ObservableObject {
    @Published var serverAccount: ServerAccount
    @Published var tootClient: TootClient?
    
    init(serverAccount: ServerAccount) {
        self.serverAccount = serverAccount
    }
    
    var avatarURL: URL? {
        guard let avatar = serverAccount.userAccount?.avatar else {
            return nil
        }
        return URL(string:avatar)
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

