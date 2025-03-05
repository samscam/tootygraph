//
//  FullScreenPhotoView.swift
//  Tootygraph
//
//  Created by Sam on 03/03/2025.
//

import SwiftUI
import TootSDK
import NukeUI

struct FullScreenPhotoView: View {
    
    var mediaAttachment: MediaAttachment
    let animationNamespace: Namespace.ID
    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    var body: some View{
        ZoomableScrollView{
            ActualPhotoView(media: mediaAttachment, fullRes: true)
        }
        .navigationTransition(.zoom(sourceID: mediaAttachment.id, in: animationNamespace))
        
    }
    
}
