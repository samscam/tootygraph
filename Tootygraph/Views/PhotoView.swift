//
//  PhotoFrame.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 09/02/2023.
//

import SwiftUI
import NukeUI
import TootSDK

extension Attachment {
  var mediaURL: URL? {
    URL(string:self.url)
  }
  
  var mediaPreviewURL: URL? {
    guard let previewUrl = self.previewUrl else { return nil }
    return URL(string:previewUrl)
  }
}

extension Attachment {
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

  @State private var flipped: Bool = false
  
  let media: Attachment
  
  var body: some View {
    if media.description != nil {
      Flipper( flipped: $flipped, frontView: frontView, rearView: rearView)
    } else {
      frontView
    }
  }
  
  @MainActor
  var frontView: some View {
    ZStack {
      Rectangle().foregroundColor(.gray.opacity(0.5))
      photoView
//      Text("\(media.width?.formatted() ?? "?") x \(media.height?.formatted() ?? "?")")
//        .bold()
//        .foregroundColor(.white)
//        .background(.black)
    }
    .frame(maxWidth:media.width, maxHeight:media.height)
    .aspectRatio(media.aspect,contentMode: .fit)
    .photoFrame()
    .overlay(alignment: .bottomTrailing) {
      if let _ = media.description {
        CornerBadge( alignment: .bottomTrailing){
          Text("ALT")
            .bold()
            .foregroundColor(.black)
            .padding(4)
        }
        .foregroundColor(.white)
        .onTapGesture{
          withAnimation {
            self.flipped = true
          }
        }
      } else {
        EmptyView()
      }
    }



  }
  
  @MainActor
  var rearView: some View {
    ZStack{
      
      photoView
        .rotation3DEffect(.radians(.pi), axis: (0,1,0))
        .blur(radius: 5)
      
      Rectangle().foregroundColor(.black.opacity(0.5))
      
      if let description = media.description {
        Text(description)
          .foregroundColor(.white)
          .padding()
      }

    }
    .onTapGesture {
      withAnimation {
        self.flipped = false
      }
    }
    .frame(maxWidth:media.width, maxHeight:media.height)
    .aspectRatio(media.aspect,contentMode: .fit)
    .photoFrame()


  }
  
  @MainActor
  var photoView: some View {

      LazyImage(url: media.mediaURL) { state in
        if let image = state.image {
          image
            .resizingMode(.aspectFit)
            
        } else {
          Color
            .accentColor.opacity(0.3)
        }
      }
//      .aspectRatio(media.aspect,contentMode: .fill)
//      .frame(maxWidth:media.width, maxHeight:media.height)



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

