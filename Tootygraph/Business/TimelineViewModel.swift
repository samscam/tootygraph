//
//  TimelineViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import Foundation
import TootSDK
import SwiftUI



extension PagedInfo: Equatable{
  public static func == (lhs: PagedInfo, rhs: PagedInfo) -> Bool {
    return lhs.minId == rhs.minId && lhs.maxId == rhs.maxId && lhs.sinceId == rhs.sinceId
  }
}

enum PagingState: Equatable {
  case nothing
  case loadingFirst
  case resting
  case lodingNext
  case end
}
enum PagingErrors: Error {
  case noMoreResults
}

class TimelineViewModel: ObservableObject {
  
  @Published var posts: [PostWrapper] = []
  @Published var loading: Bool = false
  @Published var name: String = ""
  
  private var client: TootClient
  
  private let threshold = 2
  
  init(client: TootClient){
    self.client = client
    loadInitial()
  }
  
  var pagingState: PagingState = .nothing
  var nextPage: PagedInfo? = nil
  
  func loadInitial(){
    guard pagingState == .nothing else { return }
    pagingState = .loadingFirst
    Task{
      do {
        try await self.loadMore()
      } catch {
        print("Oh noes \(error)")
      }
    }
  }
  
  func loadMore() async throws {
    await setLoading(true)
    
    let result = try await client.getHomeTimeline(nextPage)
    
    if Task.isCancelled {
      pagingState = .resting
      return
    }
    
    guard result.result.count > 0 else {
      pagingState = .end
      throw PagingErrors.noMoreResults
    }
    
    nextPage = PagedInfo(maxId:result.info.maxId)
    
    let filteredPosts = filterPosts(result.result)
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.posts.append(contentsOf: filteredPosts)
      self.pagingState = .resting
    }
    
    await setLoading(false)
  }
  
  private var currentTask: Task<Void, Never>? {
      willSet {
          if let task = currentTask {
              if task.isCancelled { return }
              task.cancel()
              // Setting a new task cancelling the current task
          }
      }
  }


  
  func onItemAppear(_ post: PostWrapper){
    if pagingState == .end {
      return
    }
    
    if pagingState == .lodingNext || pagingState == .loadingFirst {
      return
    }
    
    guard let index = posts.firstIndex(where: { $0.id == post.id }) else {
         return
     }
    
    let thresholdIndex = posts.index(posts.endIndex, offsetBy: -threshold)
        if index != thresholdIndex {
            return
        }
    
    pagingState = .lodingNext
    currentTask = Task {
      do{
        try await loadMore()
      } catch {
          print(error)
      }
    }
  }
  
  /// Forces the stream to refresh
  func refresh() async throws {
//    await setLoading(true)
//    try await client.data.refresh(.timeLineHome)
//    try await client.data.refresh(.verifyCredentials)
//    await setLoading(false)
  }
  
  @MainActor private func setPosts(_ posts: [PostWrapper]) {
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

                let filteredPosts = filterPosts(updatedPosts)
                await setPosts(filteredPosts)
              }
            
          }
      }
  
  private func filterPosts(_ posts: [Post]) -> [PostWrapper] {
    return posts.map{
      $0.displayPost
    }.filter{ $0.mediaAttachments.count > 0 }
      .map{ PostWrapper($0,client:client) }
  }
  
}

