//
//  PhotoFrame.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 09/02/2023.
//

import SwiftUI
import NukeUI
import NukeVideo
import TootSDK
import Gifu

extension MediaAttachment {
    var mediaURL: URL? {
        URL(string:self.url)
    }
    
    var mediaPreviewURL: URL? {
        guard let previewUrl = self.previewUrl else { return nil }
        return URL(string:previewUrl)
    }
}

extension MediaAttachment {
    var aspect: CGSize {
        guard let original = meta?.original,
              let width = original.width, let height = original.height else { return CGSize.zero }
        
        return CGSize(width: width, height: height)
    }
    
    var width: CGFloat? {
        guard let width = meta?.original?.width else { return nil }
        return CGFloat(width)
    }
    
    var height: CGFloat? {
        guard let height = meta?.original?.height else { return nil }
        return CGFloat(height)
    }
}

struct PhotoView: View {
    
    @Environment(SettingsManager.self) private var settings: SettingsManager?
    
    @State private var flipped: Bool = false
    
    let media: MediaAttachment
    
    var body: some View {
        Group{
            if media.description != nil {
                Flipper( flipped: $flipped, frontView: frontView, rearView: rearView)
                    .geometryGroup()
            } else {
                frontView
            }
            
        }
        .onAppear{
            flipped = settings?.descriptionsFirst ?? false
        }
    }
    
    
    var frontView: some View {
        ZStack {
            Rectangle().foregroundColor(.gray.opacity(0.5))
            photoView
        }
        .frame(maxWidth:media.width, maxHeight:media.height)
        .aspectRatio(media.aspect,contentMode: .fit)
        .photoFrame()
        .overlay(alignment: .topLeading) {
            if media.description != nil {
                CornerBadge( alignment: .topLeading){
                    Text("ALT")
                        .bold()
                        .foregroundColor(.black)
                        .padding(4)
                }
                .foregroundColor(.white)
                .onTapGesture{
                    print("FLIP!")
                    withAnimation (.spring()){
                        self.flipped = true
                    }
                }
            } else {
                EmptyView()
            }
        }
        
        
        
    }
    
    var rearView: some View {
        ZStack{
            
            photoView
                .rotation3DEffect(.radians(.pi), axis: (0,1,0))
                .blur(radius: 5)
            
            Rectangle().foregroundColor(.black.opacity(0.6))
            
            if let description = media.description {
                Text(description)
                    .foregroundColor(.white)
                    .padding()
            }
            
        }
        .onTapGesture {
            withAnimation (.spring()){
                self.flipped = false
            }
        }
        .frame(maxWidth:media.width, maxHeight:media.height)
        .aspectRatio(media.aspect,contentMode: .fit)
        .photoFrame()
        
        
    }
    
    var photoView: some View {
        Group{
            if media.type == .image {
                LazyImage(url: media.mediaURL, transaction: .init(animation: .default)) { state in
                    
                    if let image = state.image {
                        
                        image.resizable().aspectRatio(contentMode: .fit)
                    } else if let error = state.error {
                        ZStack{
                            Color.red
                            Text(error.localizedDescription)
                        }
                        
                    }
                }
            } else {
                NukeVideoView(asset: media.mediaURL)
            }
        }
        .aspectRatio(media.aspect,contentMode: .fill)
        .frame(maxWidth:media.width, maxHeight:media.height)
        
    }
}

private struct PhotoFrame: ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color.white)
            .border(.white, width:10)
            .shadow(color:.black.opacity(0.3), radius: 10)
    }
    
}

extension View {
    func photoFrame() -> some View {
        modifier(PhotoFrame())
    }
}


#Preview(traits: .sizeThatFitsLayout){
    let media = TestAttachments.attachmentFor("alpaca.jpeg",description:"Well this is very exciting")

    return PhotoView(media: media).padding()
}

