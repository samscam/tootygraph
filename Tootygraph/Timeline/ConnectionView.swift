//
//  ConnectionView.swift
//  Tootygraph
//
//  Created by Sam on 21/01/2024.
//

import Foundation
import SwiftUI
import TootSDK

struct ConnectionView: View {
    var connection: Connection
    
    var body: some View {
        
        switch connection.connectionState {
            
        case .connecting:
            
            VStack{
                Text("Connecting").font(.title)
                ProgressView().progressViewStyle(.circular)
            }
            
        case .error(let error):
            
            VStack{
                Text("Error").font(.title)
                Text(error.localizedDescription)
            }
            
        case .connected:
            ForEach(connection.feeds, id:\.id) { feed in
                
                
                FeedView(feed: feed)
                    .palette(connection.palette)
                    .navigationBarTitleDisplayMode(.inline)
                
            }
        }
    }
}
