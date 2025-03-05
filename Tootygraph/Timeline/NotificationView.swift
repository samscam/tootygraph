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
    let animationNamespace: Namespace.ID
    
    @Environment(\.palette) var palette: Palette
    @Environment(SettingsManager.self) var settings: SettingsManager
    
    var body: some View {
        HStack(alignment:.top){
            
            Image(systemName: notification.type.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32,height:32)
                .foregroundStyle(.tint)
                .rotationEffect(.degrees(-5))
                .offset(y: 20)
            
            VStack(alignment: .leading, spacing:5){
                
                
                if let post = notification.post {
                    if notification.type == .mention {
                        PostView(post: PostController(post, settings: settings), animationNamespace: animationNamespace)
                    } else {
                        AvatarView(account: notification.account)
                        PostView(post: PostController(post, settings: settings), animationNamespace: animationNamespace)
                            .compactTextContent
                    }
                }
            }.padding(10)
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
        default:
            return "questionmark.bubble.fill"
        }
    }
}
