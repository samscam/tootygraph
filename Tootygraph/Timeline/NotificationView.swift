//
//  NotificationView.swift
//  Tootygraph
//
//  Created by Sam on 31/01/2024.
//

import Foundation
import SwiftUI
import TootSDK

struct NotificationView: View {
    
    let notification: TootNotification
    @Environment(\.palette) var palette: Palette
    
    var body: some View {
        HStack(alignment:.top){
            
            Image(systemName: notification.type.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32,height:32)
                .foregroundStyle(.tint)
                .rotationEffect(.degrees(-5))
            
            VStack(alignment: .leading, spacing:5){
                AvatarView(account: notification.account)
                
                if let post = notification.post {
                    PostView(post: PostController(post))
                        .compactTextContent

                }
            }.padding(5)
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(palette.postBackground)
                }
        }
        


    }
}

struct CollectedNotificationView: View {
    let notification: TootNotification
    
    var body: some View {
        Image(systemName: notification.type.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40,height:40)
        
    }
}

extension TootNotification.NotificationType {
    var icon: String {
        switch self {
        
        case .follow:
            return "fan.fill"
        case .mention:
            return "quote.bubble.fill"
        case .repost:
            return "tornado"
        case .favourite:
            return "heart.fill"
        case .poll:
            return "chart.pie.fill"
        case .followRequest:
            return "person.crop.circle.badge.questionmark.fill"
        case .post:
            return "paperplane.fill"
        case .update:
            return "light.beacon.max.fill"
        }
    }
}
