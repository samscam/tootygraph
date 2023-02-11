//
//  ContentView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 04/02/2023.
//

import SwiftUI
import Boutique

struct TimelineView: View {
  @StateObject var server: Server
  

  init(server: Server){
    _server = StateObject<Server>(wrappedValue: server)
  }
  
  @State private var statuses: [Status] = []
  @State private var showSettings: Bool = false
  
  @State private var selectedStatus: Status?
  @State private var selectedMedia: MediaAttachment?
  
  @Namespace var photoNamespace
  
  @EnvironmentObject var settings: Settings
  
  var body: some View {
    
    
    ScrollView {
      LazyVStack{

        ForEach(statuses) { status in
          StatusView(status: status,onSelected: onSelected, photoNamespace: photoNamespace)
            .padding(20)
        }
      }
    }
    
    .refreshable {
      
      do {
        try await server.fetchPublicTimeline()
      } catch {
        print(error)
      }
      
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      BottomBar()
      
    }
    
    .onReceive(server.$publicTimeline.$items) { output in
      self.statuses = output.sorted{ $0.createdAt > $1.createdAt }
    }
    .onAppear{
      Task{
        do {
          try await server.fetchPublicTimeline()
        } catch {
          print(error)
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
  
  func onSelected(status: Status, media: MediaAttachment){
    withAnimation{
      selectedStatus = status
      selectedMedia = media
    }
  }
  
  func dismiss(){
    withAnimation{
      selectedStatus = nil
      selectedMedia = nil
    }
  }
}

struct TimelineView_Previews: PreviewProvider {
  static var previews: some View {
    let server=Server(baseURL: URL(string:"https://togl.me/api/v1/timelines/public")!)
    TimelineView(server: server)
  }
}
