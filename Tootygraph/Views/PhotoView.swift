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

  let media: Attachment
  
  var body: some View {
    if media.description != nil {
      Flipper( frontView: frontView, rearView: rearView)
    } else {
      frontView
    }
  }
  
  @MainActor
  var frontView: some View {
    ZStack{
      photoView
    }
    .photoFrame()
    .if(media.description != nil, transform: { view in
      view
        .overlay(alignment: .bottomTrailing) {
          Text("ALT")
            .foregroundColor(.black)
            .padding(.bottom, 15)
            .padding(.horizontal, 20)
            .background(Color.white.opacity(1.0))
            .padding(.horizontal, -20)
            .rotationEffect(.radians( -.pi / 4))
            .padding(.top, 20)
            .padding(.leading, 20)
            .clipShape(Rectangle())
        }
    })

  }
  
  @MainActor
  var rearView: some View {
    ZStack{
      
      photoView
        .blur(radius: 5)
      
      Rectangle().foregroundColor(.black.opacity(0.5))
      
      if let description = media.description {
        Text(description)
          .foregroundColor(.white)
          .padding()
      }

    }
    .photoFrame()
  }
  
  @MainActor
  var photoView: some View {
    LazyImage(url: media.mediaURL) { state in
      if let image = state.image {
        image
          .resizingMode(.aspectFill)
        
      } else {
        Color
          .accentColor.opacity(0.3)
      }
    }
    .frame(maxWidth:media.width, maxHeight:media.height)
    .aspectRatio(media.aspect,contentMode: .fit)
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
