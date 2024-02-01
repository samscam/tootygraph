//
//  NotificationsFeed.swift
//  Tootygraph
//
//  Created by Sam on 31/01/2024.
//

import Foundation
import TootSDK
import SwiftUI
import Combine

@MainActor
@Observable
class NotificationsFeed: Feed {
    
    let id: UUID = UUID()
    
    var items: [any FeedItem] = []

    var iconName: String = "party.popper.fill"
    
    private let tootClient: TootClient
    
    var pageInfo: PagedInfo? = nil
    
    @ObservationIgnored
    private var itemsSet = CurrentValueSubject<Set<TootNotification>,Never>(Set<TootNotification>())
    
    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []
    
    init(client: TootClient){
        self.tootClient = client
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
        
        let result = try await tootClient.getNotifications( pageInfo, limit: 30)
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
}

extension TootNotification: FeedItem {
    
}
