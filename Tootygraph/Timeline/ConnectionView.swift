//
//  ConnectionView.swift
//  Tootygraph
//
//  Created by Sam on 21/01/2024.
//

import Foundation
import SwiftUI
import Boutique
import TootSDK

struct ConnectionView: View {
    var connection: Connection
    @EnvironmentObject var settings: SettingsManager
    
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
                    NavigationStack{
                        FeedView(feed: feed)
                            .palette(connection.palette)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            
            }
        }
            
    
}
