//
//  UserAccountWrapper.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 09/07/2023.
//

import Foundation
import TootSDK

struct ServerAccount: Codable, Equatable, Identifiable, Hashable {
  
  let id: String
  let username: String
  let instanceURL: URL
  let accessToken: String?
  var userAccount: Account?
  
}
