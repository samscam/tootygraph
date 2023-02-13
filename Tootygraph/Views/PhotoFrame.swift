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
}

struct PhotoFrame: View {
  let media: Attachment
  
  var body: some View {
    LazyImage(url: media.mediaURL) { state in
      if let image = state.image {
        image
          .resizingMode(.aspectFill)
//          .frame(idealWidth:media.meta?.original?.width,  idealHeight:media.meta?.original?.height)
        
      } else {
        Color
          .accentColor.opacity(0.3)
//          .frame(idealWidth:media.meta?.original?.width,  idealHeight:media.meta?.original?.height)
        
        
      }
    }
    .background(Color.white)
    .padding(10)
    .border(.white, width:10)
    .aspectRatio(media.aspect,contentMode: .fit)
    .frame(maxHeight:512)
    .shadow(color:.black.opacity(0.3), radius: 10)
    .padding(.bottom,-20)
    
  }
}
