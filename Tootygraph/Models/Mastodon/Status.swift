//
//  Status.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 05/02/2023.
//

import Foundation
import SwiftSoup

struct Status: Codable, Identifiable, Hashable {
  static func == (lhs: Status, rhs: Status) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  let id: String
  let createdAt: Date
  let mediaAttachments: [MediaAttachment]
  let account: Account
  let content: String
  
  var parsedContent: String? {
    do {
      let doc = try SwiftSoup.parseBodyFragment(content)
      let body:Element? = doc.body()
      return try body?.text()
    } catch {
      print(error)
      return nil
    }
  }
}



