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
import Blurhash

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
    
    var size: CGSize? {
        guard let width, let height else { return nil }
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
    
    enum AnimationPhase: Double, CaseIterable {
        case hidden = 0
        case midpoint = 1
        case visible = 2
    }
    
    @Environment(SettingsManager.self) private var settings: SettingsManager?
    
    @State private var showingDescription: Bool = true
    
    let media: MediaAttachment
    
    var body: some View {
            VStack(alignment:.leading){
                
                frontView
                    .overlay(alignment: .bottomTrailing) {
                        if media.description != nil {
                            CornerBadge( alignment: .bottomTrailing){
                                Image(systemName: "figure")
                                    .foregroundStyle(.black)
                                    .rotationEffect(showingDescription ? .degrees(180) : .zero )
//                                Text("ALT")
//                                    .bold()
//                                    .foregroundColor(.black)
                                    .padding(4)
                            }
                            .offset(CGSize(width: 1, height: 1))
                            .foregroundColor(Color(white:1.0,opacity:0.7))
                            .onTapGesture{
                                print("FLIP!")
                                withAnimation (.spring()){
                                    self.showingDescription = !self.showingDescription
                                }
                            }
                        } else {
                            EmptyView()
                        }
                    }

                Group{
                    if let description = media.description, showingDescription {
                        Text(description)
                            .font(.custom("American Typewriter", size: 16))
                        
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(white: 0.3, opacity: 1.0))
//                            .padding(10)
                            .animation(.easeIn, value: showingDescription)
                        
                        
                    }
                }
            }
            .transaction {
                $0.animation = $0.animation?.delay(showingDescription ? 0.2 : 0)
            }
            .frame(maxWidth:media.width)
            
            .padding(10)
            .background(
                Rectangle().fill(.white)
                    .shadow(color:.black.opacity(0.3), radius: 10)                    .transaction {
                        $0.animation = $0.animation?.delay(showingDescription ? 0: 0.2)
                    })
            
            .onAppear {
                showingDescription = settings?.descriptionsFirst ?? false
            }
            .geometryGroup()
        


        
    }
    
    
    var frontView: some View {
        ZStack{
            blurhashView
            photoView
        }
        .frame(maxWidth:media.width, maxHeight:media.height)
        .aspectRatio(media.aspect,contentMode: .fit)
        
        .overlay{
            Rectangle()
                
                .stroke(lineWidth: 3)
                .foregroundStyle(Color.gray)
                .blur(radius: 10)
                .clipped()
        }
        
        
    }
    
    var blurhashView: some View {
        Group{
            let size = CGSize(width:20,height:20)
            if let blurhash = media.blurhash,
               
               let uiImage = UIImage(blurHash: blurhash, size: size, punch: 1) {
                Image(uiImage: uiImage).resizable()
            } else {
                EmptyView()
            }
        }
    }
    
    var photoView: some View {
        Group{
            if media.type == .image {
                
                LazyImage(url: media.mediaURL
                          ,transaction: .init(animation: Animation.easeInOut(duration: 0.4))
                ) { state in
                    
                    if let image = state.image {
                        
                        image.resizable().aspectRatio(contentMode: .fit)
                    } else if let error = state.error {
                        ZStack{
                            Color.red
                            Text(error.localizedDescription)
                            
                        }
                        
                    } else {
                        Color.clear
                    }
                }
            } else {
                NukeVideoView(asset: media.mediaURL)
            }
        }
        
        
        
    }
}

private struct PhotoFrame: ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color.white)
            .border(.white, width:10)
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

#Preview(traits: .sizeThatFitsLayout){
    let media = TestAttachments.attachmentFor("macs.jpeg",description:"Well this is very exciting")
    
    return PhotoView(media: media).padding()
}
