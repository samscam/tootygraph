//
//  TootFeed.swift
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
@Observable
class TootFeed: Feed {

    
    let id: UUID = UUID()
    

    var items: [any FeedItem] = []
    
    var loading: Bool = false
    
    var palette: Palette
    var accountNiceName: String
    
    private (set) var client: TootClient
    
    @ObservationIgnored
    private var postsSet = CurrentValueSubject<Set<PostController>,Never>(Set<PostController>())
    
    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []
    
    @ObservationIgnored
    private let threshold = 2
    
    @ObservationIgnored
    let timeline: Timeline
    
    @ObservationIgnored
    @Injected(\.settingsManager) var settings: SettingsManager

    
    
    init(client: TootClient, timeline: Timeline, palette: Palette, accountNiceName: String){
        self.client = client
        self.timeline = timeline
        self.palette = palette
        self.accountNiceName = accountNiceName
        
        // Binding for postsSet to apply filtering and update posts
        
        postsSet
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
            .assign(to: \.items, on: self)
            .store(in: &cancellables)
        
        loadInitial()
    }
    
    var iconName: String {
        return timeline.iconName
    }
    
    var pagingState: PagingState = .nothing
    var nextPage: PagedInfo? = nil
    
    func loadInitial(){
        guard pagingState == .nothing else { return }
        pagingState = .loadingFirst
        Task{
            do {
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
    
    
    func onItemAppear(_ item: any FeedItem) {
        if pagingState == .end {
            return
        }
        
        if pagingState == .lodingNext || pagingState == .loadingFirst {
            return
        }
        
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -threshold)
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
        
        let postWrappers = newPosts.map{ PostController($0, client: client)}
        
        for post in postWrappers {
            let (inserted, _) = postsSet.value.insert(post)
            if !inserted {
                postsSet.value.update(with: post)
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

//extension TootFeed: Identifiable{
//    
//    var id: FeedIdentifier {
//        return FeedIdentifier(account: accountNiceName, timeline: timeline.stringName)
//    }
//    
//}

extension TootFeed: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TootFeed: Equatable {
    static func == (lhs: TootFeed, rhs: TootFeed) -> Bool {
        lhs.id == rhs.id
    }
}


extension Timeline{
    var stringName: String {
        switch self {
            case .bookmarks: return "Bookmarks"
            case .favourites: return "Favourites"
            case .federated: return "Federated"
            case .home: return "Home"
            case .hashtag: return "Hashtag"
            case .list: return "List"
            case .user: return "User"
            case .local: return "Local"
        }
    }
}
