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
  var color: CodableColor
  let instanceURL: URL
  let accessToken: String?
  var userAccount: Account?
    
    var niceName: String {
        if let host = instanceURL.host {
            return "\(username)@\(host)"
        }
        return username
    }
}
