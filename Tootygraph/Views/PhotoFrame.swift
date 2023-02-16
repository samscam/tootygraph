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
          
      } else {
        Color
          .accentColor.opacity(0.3)
      }
    }
    .frame(maxWidth:Double(media.meta?.original?.width ?? 10),  maxHeight:Double(media.meta?.original?.height ?? 10))

    .padding(10)
    .background(Color.white)
    .border(.white, width:10)

    
    .aspectRatio(media.aspect,contentMode: .fit)

    .shadow(color:.black.opacity(0.3), radius: 10)
    .padding(.bottom,-15)
    
  }
}
