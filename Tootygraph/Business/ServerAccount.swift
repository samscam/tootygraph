//
//  UserAccountWrapper.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 09/07/2023.
//

import Foundation
import TootSDK
import SwiftUI

struct ServerAccount: Codable, Equatable, Identifiable, Hashable {
    
    let id: String
    let username: String
    var hue: Hue
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
