//
//  Server.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 05/02/2023.
//

import Foundation

import Boutique

extension Store where Item == Status {

    // Initialize a Store to save our images into
    static let statusesStore = Store<Status>(
        storage: SQLiteStorageEngine.default(appendingPath: "Statuses")
    )

}


class Server: ObservableObject{
  
  let baseURL: URL
  @Stored(in: .statusesStore) var publicTimeline: [Status]

  init(baseURL: URL) {
    self.baseURL = baseURL
//    self._publicTimeline = Stored(in: .statusesStore)
  }
  
  var publicTimelineURL: URL {
    baseURL.appending(path: "api/v1/timelines/public")
  }
  
  @MainActor
  func fetchPublicTimeline() async throws {
    let (data, _) = try await URLSession.shared.data(from: publicTimelineURL)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .custom({ decoder -> Date in
      let container = try decoder.singleValueContainer()
      let str = try container.decode(String.self)
      let dateFormatter = ISO8601DateFormatter()
      dateFormatter.formatOptions = [.withFractionalSeconds,.withInternetDateTime]
      guard let date = dateFormatter.date(from: str) else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Oh dear dodgy date \(str)")
      }
      return date
    })
    let result = try decoder.decode([Status].self, from: data)
    
    let filtered = result.filter { status in
      return status.mediaAttachments.count > 0
    }
    Task{
      do {
        try await addStatuses(filtered)
      } catch {
        print("failed to insert new statuses")
      }
    }
  }
  
  func addStatuses(_ newStatuses: [Status]) async throws{
    try await $publicTimeline.insert(newStatuses)
  }
}
