//
//  TootFeed.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 30/02/2024.
//


import Foundation

@MainActor
protocol Feed: Identifiable, Observable {
    var id: UUID { get }
    
    var items: [any FeedItem] { get }
    var iconName: String { get }
    
    func onItemAppear(_ item: any FeedItem)
    func loadInitial()
    func refresh() async throws
    
}

protocol FeedItem: Identifiable, Observable {
    var id: String { get }
}
