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
    @ObservedObject var connection: ConnectionController
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
            ForEach(connection.timelines){ timeline in
                TimelineView(timelineController: timeline)
            }
        }
        
    }
}
