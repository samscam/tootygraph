//
//  PostWrapper.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 23/02/2023.
//

import Foundation
import TootSDK

class PostWrapper: ObservableObject, Identifiable{
  
  
  let id: String
  
  @Published private(set) var post: Post
  private(set) var attributedContent: AttributedString
  
  // Pre-generate jaunty angles for display...
  var jauntyAngles: [Double] = []

  weak var client: TootClient?
  
  init(_ post: Post, client: TootClient? = nil){
    
    self.client = client
    self.post = post
    self.id = post.id
    
    // Pre-render html content
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    let renderer = AppKitAttribStringRenderer()
    #else
    let renderer = UIKitAttribStringRenderer()
    #endif
    let attrib = renderer.render(post.displayPost).attributedString
    self.attributedContent = AttributedString(attrib)
    
    // Pre-generate adequate quantities of random jaunty angles
    for _ in 0...post.mediaAttachments.count + 2 {
        jauntyAngles.append(Double.random(in: -3...3))
    }
    
  }
  
  func toggleFavourite() async throws {
    let result: Post?
    if let favorited = post.favourited, favorited == true {
      result = try await client?.unfavouritePost(id: post.id)
    } else {
      result = try await client?.favouritePost(id: post.id)
    }
    
    if let result = result {
      await MainActor.run{
        post = result
      }
    }
  }
  
  
}
