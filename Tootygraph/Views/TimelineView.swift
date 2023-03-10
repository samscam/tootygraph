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
  @StateObject var timelineViewModel: TimelineViewModel
  
  init(client: TootClient, settings: Settings){
    self.client = client
    _timelineViewModel = StateObject(wrappedValue: TimelineViewModel(client: client, settings: settings))
    
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
  }
}

//struct TimelineView_Previews: PreviewProvider {
//  static var previews: some View {
//    let server=Server(baseURL: URL(string:"https://togl.me/api/v1/timelines/public")!)
//    TimelineView(server: server)
//  }
//}
