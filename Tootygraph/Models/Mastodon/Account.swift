//
//  Account.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import Foundation

struct Account: Codable, Identifiable {
  let id: String
  let username: String
  let acct: String
  let displayName: String
  let avatar: URL?
}
