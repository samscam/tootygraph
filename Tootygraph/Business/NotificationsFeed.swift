//
//  NotificationsFeed.swift
//  Tootygraph
//
//  Created by Sam on 31/01/2024.
//

import Foundation
@preconcurrency import TootSDK
import SwiftUI
import Combine

@MainActor
@Observable
class NotificationsFeed: Feed {
    
    let id: UUID = UUID()
    
    var items: [any FeedItem] = []
    
    let name: String = "Notifications"

    var iconName: String = "party.popper.fill"
    
    let client: TootClient
    
    var pageInfo: PagedInfo? = nil
    
    @ObservationIgnored
    private var itemsSet = CurrentValueSubject<Set<TootNotification>,Never>(Set<TootNotification>())
    
    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []
    
    init(client: TootClient){
        self.client = client
        setupBindings()
    }
    
    func onItemAppear(_ item: any FeedItem) {
        
    }
    
    func loadInitial() {
        Task{
            do {
                try await self.loadMore()
            } catch {
                print("Oh dear, error loading notifications")
            }
        }
    }
    
    func refresh() async throws {
        
    }
    
    /// Private functions --
    private func loadMore() async throws {
        
        let result = try await client.getNotifications( pageInfo, limit: 30)
        pageInfo = result.nextPage
        addItems(result.result)
    }
    
    private func addItems(_ notifications: [TootNotification]){
        for item in notifications {
            let (inserted, _) = itemsSet.value.insert(item)
            if !inserted {
                itemsSet.value.update(with: item)
            }
        }
    }
    
    private func setupBindings(){
        itemsSet
            .map{ posts in
                return posts.sorted {
                    $0.id > $1.id
                }
            }
            .assign(to: \.items, on: self)
            .store(in: &cancellables)
    }
    
    func feedFor(_ account: Account) -> (any Feed)? {
        
        let timeline = Timeline.user(userID: account.id)
        let feed = TootFeed(client: client, timeline: timeline, palette: Palette.random(), accountNiceName: account.acct)
        return feed
    }
}

extension TootNotification: @retroactive Observable {}
extension TootNotification: FeedItem {
    
}
