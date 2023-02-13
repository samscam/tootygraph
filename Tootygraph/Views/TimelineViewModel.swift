//
//  TimelineViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import Foundation
import TootSDK

class TimelineViewModel: ObservableObject {
  
  @MainActor @Published var posts: [Post] = []
  @MainActor @Published var loading: Bool = false
  @MainActor @Published var name: String = ""
  
  private var client: TootClient
  init(client: TootClient){
    self.client = client
    Task{
      await setBindings()
    }
  }
  
  func refresh() async throws {
    await setLoading(true)
    try await client.data.refresh(.timeLineHome)
    try await client.data.refresh(.verifyCredentials)
    await setLoading(false)
  }
  
  @MainActor private func setPosts(_ posts: [Post]) {
      self.posts = posts
  }
  
  @MainActor private func setLoading(_ loading: Bool) {
      self.loading = loading
  }
  
  @MainActor private func setName(_ name: String) {
      self.name = name
  }
  
  private func setBindings() async {

          
          Task {
              for await updatedPosts in try await client.data.stream(.timeLineHome)
            {
//                  let renderer = UIKitAttribStringRenderer()
                  
//                  let feedPosts = updatedPosts.map { post in
//
//                      let html = renderer.render(post.displayPost).wrappedValue
//                      let markdown = TootHTML.extractAsPlainText(html: post.displayPost.content) ?? ""
//
//                      return FeedPost(html: html, markdown: markdown, tootPost: post)
//                  }
//
                let filteredPosts = updatedPosts.map{
                  $0.displayPost
                }.filter{ $0.mediaAttachments.count > 0 }
                  await setPosts(filteredPosts)
              }
            
            
          }
          
          // Reset data if the client changes (user has signed in/out etc
//          Task {
//              for await _ in client.values {
//                  await setPosts([])
//                  await setName("")
//              }
//          }
          
          // opt into account updates
          Task {
              for await account in try await  client.data.stream(.verifyCredentials) {
                  print("got account update")
                  await self.setName(account.displayName ?? "-")
              }
          }

      }
  
}
