//
//  ContentView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 04/02/2023.
//

import SwiftUI
import Boutique
import TootSDK



struct TimelineView: View {
    
    var timelineController: TimelineController
    
    var body: some View {
        
//        GeometryReader{ geometry in
            List(timelineController.posts) { post in
                
                PostView(post: post)
                    .padding(20)
                    .onAppear{
                        timelineController.onItemAppear(post)
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
                    try await timelineController.refresh()
                } catch {
                    print("Oh noes \(error)")
                }
            }
            .onAppear{
                timelineController.loadInitial()
            }
//            .navigationTitle(timelineController.name)
            
        }
//    }
}


//struct TimelineView_Previews: PreviewProvider {
//  static var previews: some View {
//    let server=Server(baseURL: URL(string:"https://togl.me/api/v1/timelines/public")!)
//    TimelineView(server: server)
//  }
//}
