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
  let client: TootClient

  init(client: TootClient){
    self.client = client
    _timelineViewModel = StateObject(wrappedValue: TimelineViewModel(client: client))
  }
  
  @StateObject var timelineViewModel: TimelineViewModel
  
  
  @State private var showSettings: Bool = false
  
  @State private var selectedPost: Post?
  @State private var selectedMedia: Attachment?
  
  @Namespace var photoNamespace
  
  @EnvironmentObject var settings: Settings
  
  var body: some View {
    
    
    ScrollView {
      LazyVStack{

        ForEach(timelineViewModel.posts) { post in
          StatusView(post: post, onSelected: onSelected, photoNamespace: photoNamespace)
            .padding(20)
        }
      }
    }
    
    .refreshable {
        do {
          try await timelineViewModel.refresh()
        } catch {
         print("Oh noes \(error)")
       }
      
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      BottomBar()
      
    }
    
//    .onReceive(server.$publicTimeline.$items) { output in
//      self.statuses = output.sorted{ $0.createdAt > $1.createdAt }
//    }
    .onAppear{
      
      Task{
        do {
          try await timelineViewModel.refresh()
        } catch {
         print("Oh noes \(error)")
       }
      }
    }
    .navigationTitle("Tootygraph")
//    .toolbar {
//      ToolbarItem{
//        Button {
//          Task{
//            try? await server.fetchPublicTimeline()
//          }
//        } label: {
//          Image(systemName: "fan.floor")
//        }
//
//      }
//      ToolbarItem(placement:.primaryAction){
//        SettingsMenu()
//      }
//    }
    
  }
  
  func onSelected(post: Post, media: Attachment){
    withAnimation{
      selectedPost = post
      selectedMedia = media
    }
  }
  
  func dismiss(){
    withAnimation{
      selectedPost = nil
      selectedMedia = nil
    }
  }
}

//struct TimelineView_Previews: PreviewProvider {
//  static var previews: some View {
//    let server=Server(baseURL: URL(string:"https://togl.me/api/v1/timelines/public")!)
//    TimelineView(server: server)
//  }
//}
