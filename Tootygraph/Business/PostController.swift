//
//  PostWrapper.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 23/02/2023.
//

import Foundation
import TootSDK

@Observable
class PostController {
    
    let id: String
    
    private(set) var post: Post
    private(set) var attributedContent: AttributedString
    
    var mediaAttachments: [MediaAttachment] {
        return post.displayPost.mediaAttachments
    }
    
    var displayPost: Post {
        return post.displayPost
    }
    
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
        for _ in 0...post.displayPost.mediaAttachments.count + 4 {
            jauntyAngles.append(Double.random(in: -2...2))
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
                post = result.displayPost
            }
        }
    }
    
    func toggleBoost() async throws {
        let result: Post?
        if let boosted = post.reposted, boosted == true {
            result = try await client?.unboostPost(id: post.id)
        } else {
            result = try await client?.boostPost(id: post.id)
        }
        
        if let result = result {
            await MainActor.run{
                post = result.displayPost
            }
        }
    }
    
    
}

extension PostController:  Identifiable {
    
}

extension PostController: Hashable {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PostController: Equatable {
    nonisolated static func == (lhs: PostController, rhs: PostController) -> Bool {
        lhs.id == rhs.id
    }
}
