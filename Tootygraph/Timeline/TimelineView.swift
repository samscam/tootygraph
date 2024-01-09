//
//  ContentView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 04/02/2023.
//

import SwiftUI
import Boutique
import TootSDK

struct ConnectionView: View {
    @ObservedObject var connection: Connection
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        if let tootClient = connection.tootClient {
            TimelineView(client: tootClient, timeline: .home, settings: settings)
        } else {
            Button {
              Task{
                try? await connection.connect()
              }
            } label: {
              Text("Connect")
            }.buttonStyle(.borderedProminent)
        }
    }
}

struct TimelineView: View {
    
    let client: TootClient
    let timeline: Timeline
    
    @StateObject var timelineViewModel: TimelineViewModel
    
    init(client: TootClient, timeline: Timeline, settings: Settings){
        self.client = client
        
        self.timeline = timeline
        _timelineViewModel = StateObject(wrappedValue: TimelineViewModel(client: client, timeline: timeline, settings: settings))
        
    }
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var accountsManager: AccountsManager
    
    var body: some View {
        
        GeometryReader{ geometry in
            List(timelineViewModel.posts) { post in
                
                StatusView(post: post, geometry: geometry)
                    .padding(20)
                    .onAppear{
                        timelineViewModel.onItemAppear(post)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(EmptyView())
            }
            .listStyle(PlainListStyle())
            .padding(0)
            //      .background{
            //        Image("wood-texture").resizable().edgesIgnoringSafeArea(.all)
            //      }
            .refreshable {
                do {
                    try await timelineViewModel.refresh()
                } catch {
                    print("Oh noes \(error)")
                }
            }
            
//            .safeAreaInset(edge: .bottom, spacing: 0) {
//                BottomBar(tootClient: client)
//            }
            .onAppear{
                timelineViewModel.loadInitial()
            }
            .navigationTitle(timelineViewModel.name)
            
        }
    }
}

//struct TimelineView_Previews: PreviewProvider {
//  static var previews: some View {
//    let server=Server(baseURL: URL(string:"https://togl.me/api/v1/timelines/public")!)
//    TimelineView(server: server)
//  }
//}
