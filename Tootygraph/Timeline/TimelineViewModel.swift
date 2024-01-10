//
//  TimelineViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 12/02/2023.
//

import Foundation
import TootSDK
import SwiftUI
import Combine


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

@MainActor
class TimelineViewModel: ObservableObject {
  
  @Published var posts: [PostWrapper] = []
  @Published var loading: Bool = false
  @Published var name: String = ""
  @Published var account: Account?
  
  private var client: TootClient
  
  @Published private var postsSet = Set<PostWrapper>()
  
  private let threshold = 2
  private let timeline: Timeline
  
  private let settings: Settings
  private var disposebag = Set<AnyCancellable>()
  
  init(client: TootClient, timeline: Timeline, settings: Settings){
    self.client = client
    self.timeline = timeline
    self.settings = settings
    self.name = client.instanceURL.absoluteString
    loadInitial()
    
    // Binding for postsSet to apply filtering and update posts
      
    $postsSet
      .combineLatest(settings.$includeTextPosts.publisher)
      .map{ (posts, includeText) in
        return posts.filter {post in

          if includeText {
            return true
          } else {
            return post.mediaAttachments.count > 0
          }
        }
      }
      .map{ posts in
        return posts.sorted {
          $0.id > $1.id
        }
      }
      .assign(to: &$posts)
      
      
  }
  
  var pagingState: PagingState = .nothing
  var nextPage: PagedInfo? = nil
  
  func loadInitial(){
    guard pagingState == .nothing else { return }
    pagingState = .loadingFirst
    Task{
      do {
        let _ = try await client.verifyCredentials()
        
        try await self.loadMore()
        await self.startStreaming()
      } catch {
        print("Oh noes \(error)")
      }
      
    }
  }
  
  func loadMore() async throws {
    self.loading = true
    
    let result = try await client.getTimeline(timeline, pageInfo: nextPage)
    
    if Task.isCancelled {
      pagingState = .resting
      return
    }
    
    guard result.result.count > 0 else {
      pagingState = .end
      throw PagingErrors.noMoreResults
    }
    
    nextPage = PagedInfo(maxId:result.info.maxId)
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.addPosts(result.result)
      self.pagingState = .resting
    }
    
    self.loading = false
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
    self.loading = true
    try await client.data.refresh(timeline)
    try await client.data.refresh(.verifyCredentials)
    self.loading = false
  }
  
  @MainActor
  private func addPosts(_ newPosts: [Post]) {
    
    let postWrappers = newPosts.map{ PostWrapper($0, client: client)}
    
    for post in postWrappers {
      let (inserted, _) = postsSet.insert(post)
      if !inserted {
        postsSet.update(with: post)
      }
    }
    
  }
  
  
  private func startStreaming() async {
      Task {
          for await updatedPosts in try await client.data.stream(timeline)
        {
            
            addPosts(updatedPosts)
          }
      }
  }
  

  
}

