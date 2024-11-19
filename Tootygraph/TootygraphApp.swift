//
//  TootygraphApp.swift
//  Tootygraph
//
//  Created by Sam on 11/01/2024.
//

import SwiftUI

import NukeUI
import Nuke
import NukeVideo


@main
struct TootygraphApp: App {
    
    @StateObject var tootygraph = Tootygraph()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(tootygraph.accountsManager)
                .environmentObject(tootygraph.settingsManager)
                .task{
                    // This is to make Nuke be able to handle videos, apparently
                    ImageDecoderRegistry.shared.register(ImageDecoders.Video.init)
                }
        }
    }
}
