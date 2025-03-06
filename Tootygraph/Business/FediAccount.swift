//
//  UserAccountWrapper.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 09/07/2023.
//

import Foundation
import TootSDK

import SwiftData

/**
 A FediAccount is the storable structure representing a user account on a server somewhere.
 
 The actual `Account` providing full details of the user from TootSDK is embedded within it and updated when connected.
 
 Suitable for storing locally and initiating a Connection.
 */
@Model
final class FediAccount: Sendable {

    @Attribute(.unique) var id: String
    
    var username: String
    var hue: Double
    var instanceURL: URL
    var avatarURL: URL?
    var headerURL: URL?
    
    var accessToken: String?
    
    @Transient
    var userAccount: Account?
    
    var niceName: String {
        "\(username)@\(host)"
    }
    
    var host: String {
        instanceURL.host ?? "unknown"
    }
    
    var palette: Palette {
        Palette(self.hue)
    }
    
    init(id: String, username: String, hue: Double, instanceURL: URL, accessToken: String?, userAccount: Account? = nil) {
        self.id = id
        self.username = username
        self.hue = hue
        self.instanceURL = instanceURL
        self.accessToken = accessToken
        self.userAccount = userAccount
    }
    
    init(_ account: Account){
        self.id = account.id
        self.username = account.username!
        self.avatarURL = URL(string:account.avatar)
        self.instanceURL = URL(string:account.url)!
        self.hue = Double.random(in: 0.0...1.0)
    }
}
