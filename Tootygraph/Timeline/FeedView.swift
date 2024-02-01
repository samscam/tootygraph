//
//  ContentView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 04/02/2023.
//

import SwiftUI
import Boutique
import TootSDK



struct FeedView: View {
    
    var feed: any Feed
    
    var body: some View {
        
//        GeometryReader{ geometry in
        List(feed.items, id:\.id) { item in
                Group{
                    switch item {
                    case let post as PostController:
                        PostView(post: post)
                    case let notification as TootNotification:
                        NotificationView(notification: notification)
                    default:
                        Text("whoopsy")
                    }
                    
                }
                    .padding(20)
                    .onAppear{
                        feed.onItemAppear(item)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(EmptyView())
            }
            .scrollClipDisabled()
            .listStyle(PlainListStyle())
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
//            .navigationTitle(feed.name)
            
        }
//    }
}


//struct TimelineView_Previews: PreviewProvider {
//  static var previews: some View {
//    let server=Server(baseURL: URL(string:"https://togl.me/api/v1/timelines/public")!)
//    TimelineView(server: server)
//  }
//}
