//
//  ContentView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 04/02/2023.
//

import SwiftUI
import TootSDK



struct FeedView: View {
    
    var feed: any Feed
    @Environment(\.palette) var palette: Palette
    @Namespace var animationNamespace
    
    var body: some View {

            ScrollView{
                LazyVStack{
                    ForEach(feed.items, id:\.id) { item in
                        Group{
                            switch item {
                            case let post as PostController:
                                PostView(post: post, animationNamespace: animationNamespace)
                            case let notification as TootNotification:
                                NotificationView(notification: notification, animationNamespace: animationNamespace)
                            default:
                                Text("whoopsy")
                            }
                            
                        }
                        .geometryGroup()
                        .padding(20)
                        .onAppear{
                            feed.onItemAppear(item)
                        }
                    }
                }
            }
            .scrollClipDisabled()
            
            .padding(0)
            .refreshable {
                do {
                    try await feed.refresh()
                } catch {
                    print("Oh noes \(error)")
                }
            }
            .onAppear{
                feed.loadInitial()
            }
            .navigationDestination(for: TootFeed.self) { childFeed in
                
                FeedView(feed: childFeed)
                
            }
            .navigationDestination(for: MediaAttachment.self) { attachment in
                FullScreenPhotoView(mediaAttachment:attachment, animationNamespace: animationNamespace)
            }
            .navigationTitle(feed.name)
            .background{
                ZStack {
                    Rectangle()
                        .fill(palette.background)
                }.ignoresSafeArea()
            }
        }
    
    
}


//struct TimelineView_Previews: PreviewProvider {
//  static var previews: some View {
//    let server=Server(baseURL: URL(string:"https://togl.me/api/v1/timelines/public")!)
//    TimelineView(server: server)
//  }
//}
