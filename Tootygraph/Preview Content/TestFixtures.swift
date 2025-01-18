//
//  TestFixtures.swift
//  Tootygraph
//
//  Created by Sam on 13/01/2024.
//

import Foundation

import TootSDK
import UIKit

enum TestPosts {
    static let justText = Post(id: "123",
                               uri: "url",
                               createdAt: Date(),
                               account: TestAccounts.sam,
                               content: "Hello, here is a test post with some text content",
                               visibility: .public,
                               sensitive: false,
                               spoilerText: "",
                               mediaAttachments:
                                [],
                               application: TootApplication(name: "fooop"),
                               mentions: [],
                               tags: [],
                               emojis: [],
                               repostsCount: 5,
                               favouritesCount: 1,
                               repliesCount: 52)
    static let postWithPics = Post(id: "1235",
                               uri: "url",
                               createdAt: Date(),
                               account: TestAccounts.alpaca,
                               content: "Here is a post with some pictures",
                               visibility: .public,
                               sensitive: false,
                               spoilerText: "",
                               mediaAttachments:
                                    [TestAttachments.attachmentFor("heaton.jpeg"), TestAttachments.attachmentFor("macs.jpeg")],
                               application: TootApplication(name: "fooop"),
                               mentions: [],
                               tags: [],
                               emojis: [],
                               repostsCount: 5,
                               favouritesCount: 1,
                               repliesCount: 52)
    
}


enum TestAttachments {
    
    static func attachmentFor(_ name: String, description: String? = nil) -> MediaAttachment{
        let url = Bundle.main.url(forResource: name, withExtension: nil)?.absoluteString ?? ""
        
        let meta = """
{ "original" : {
    "width": 1,
    "height": 1
}
}
"""
        
        let metaData = meta.data(using: .utf8)!
        let decoder = JSONDecoder()
        var attachmentMeta = try! decoder.decode(AttachmentMeta.self, from: metaData)
        
        let uiImage = UIImage(named: name)!
        attachmentMeta.original?.width = Int(uiImage.size.width)
        attachmentMeta.original?.height = Int(uiImage.size.height)
        
        return MediaAttachment(id: name, type: .image, url: url, meta: attachmentMeta, description: description)
    }
}

enum TestAccounts {
    static let sam = Account(
        displayName:"Sam Easterby-Smith",
        username:"sam",
        server: "togl.me",
        avatarName:"sam.jpeg")
    static let alpaca = Account(
        displayName:"Alpaca the White",
        username:"alpaca",
        server: "example.com",
        avatarName:"alpaca.jpeg")
}

extension Account {
    convenience init(displayName: String, username:String,server: String,avatarName: String) {
        let avatarURL = Bundle.main.url(forResource: avatarName, withExtension: nil)?.absoluteString ?? ""
        self.init(id: username,
                  username: username,
                  acct: "\(username)@\(server)",
                  url: "https://\(server)/",
                  displayName: displayName,
                  note: "",
                  avatar: avatarURL,
                  avatarStatic: "",
                  header: "",
                  headerStatic: "",
                  locked: false,
                  emojis: [],
                  discoverable: false,
                  createdAt: Date(),
                  lastPostAt: Date(),
                  postsCount: 4,
                  followersCount: 123,
                  followingCount: 141,
                  moved: nil,
                  suspended: false,
                  limited: false,
                  fields: [],
                  bot: false,
                  source: nil)
    }
    
}


