//
//  UserAccountWrapper.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 09/07/2023.
//

import Foundation
import TootSDK
import SwiftUI

/**
 A FediAccount is the storable structure representing a user account on a server somewhere.
 
 The actual `Account` providing full details of the user from TootSDK is embedded within it and updated when connected.
 
 Suitable for storing locally and initiating a Connection.
 */
struct FediAccount: Codable, Equatable, Identifiable, Hashable {
    
    let id: String
    let username: String
    var hue: Double
    let instanceURL: URL
    
    let accessToken: String?
    var userAccount: Account?
    
    var niceName: String {
        "\(username)@\(host)"
    }
    
    var host: String {
        instanceURL.host ?? "unknown"
    }
}
