//
//  MediaAttachment.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import Foundation

struct MediaAttachment: Codable, Identifiable, Equatable {
  
  static func == (lhs: MediaAttachment, rhs: MediaAttachment) -> Bool {
    lhs.id == rhs.id
  }
  
  let id: String
  let type: String
  let url: URL?
  let description: String?
  let meta: Meta?
  
  var aspect: CGSize {
    guard let original = meta?.original else { return CGSize.zero }
    return CGSize(width: original.width, height: original.height)
  }
  
  struct Meta: Codable {
    let original: MediaSize?
  }
  
  struct MediaSize: Codable {
    let width: CGFloat
    let height: CGFloat
    let aspect: Double?
  }
  
}
