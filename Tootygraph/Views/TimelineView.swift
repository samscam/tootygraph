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
  
  @State private var posts: [PostWrapper] = []
  @State private var selectedPost: PostWrapper?
  @State private var selectedMedia: Attachment?
  
  @Namespace var photoNamespace
  @Namespace var accountNamespace
  
  @EnvironmentObject var settings: Settings
  @EnvironmentObject var accountsManager: AccountsManager
  
  var body: some View {
    
    GeometryReader{ geometry in
      ScrollView {
        LazyVStack{
          
          ForEach(posts) { post in
            StatusView(post: post, onSelected: onSelected, photoNamespace: photoNamespace, accountNamespace: accountNamespace, geometry: geometry)
              .padding(20)
              .onAppear{
                timelineViewModel.onItemAppear(post)
              }
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
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      BottomBar()
      
    }
    
    .onReceive(timelineViewModel.$posts) { output in
      self.posts = output
    }
    .onAppear{
      timelineViewModel.loadInitial()
    }
    .navigationTitle("Tootygraph")
    .toolbar {
      ToolbarItem(placement:.automatic){
        SettingsMenu()
      }
      ToolbarItem(placement: .automatic) {
        Button {
          accountsManager.signOut()
        } label: {
          Image(systemName: "figure.socialdance")
          
        }
      }
    }
    
  }
  
  func onSelected(post: PostWrapper, media: Attachment){
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
