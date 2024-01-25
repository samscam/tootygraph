//
//  PhotoComposerViewModel.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 27/02/2023.
//

import SwiftUI
import TootSDK


@MainActor
class PostComposerViewModel: ObservableObject{

    @Published var composedText: String = ""
    @Published var remainingChars: Int = 0
    @Published var maxChars: Int? = nil
    @Published var replyingTo: String? = nil
    
    private let tootClient: TootClient?
    let replyContext: PostController?
    
    init(tootClient: TootClient?,replyContext: PostController? = nil){
        
        self.replyContext = replyContext
        self.tootClient = tootClient
        

        
        $composedText.combineLatest($maxChars).map{(text,max) in
            if let max {
              return max - text.count
            } else {
                return text.count
            }
        }.assign(to: &$remainingChars)
        
        if let replyContext {
           let replyingUser = replyContext.post.displayPost.account.acct
            replyingTo = replyingUser
            composedText = "@\(replyingUser) "
        }
        
        Task{
            self.maxChars = try await tootClient?.getInstanceInfo().configuration?.posts?.maxCharacters
        }
    }
    
    func post() async throws{
        guard let tootClient else {
            return // should throw something
        }

        var params: PostParams = PostParams(post: composedText, visibility: .public)
        if let replyContext {
            params.inReplyToId = replyContext.displayPost.id
        }
        _ = try await tootClient.publishPost(params)
    }
}

