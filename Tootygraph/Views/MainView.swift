//
//  MainView.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import SwiftUI

struct MainView: View {
  let server=Server(baseURL: URL(string:"https://togl.me")!)
  
  @StateObject var settings = Settings()
  

  var body: some View {
    NavigationStack{
      TimelineView(server: server)
        .background{
          Image("wood-texture").resizable().edgesIgnoringSafeArea(.all)
        }
        .environmentObject(settings)
    }
  }
}
