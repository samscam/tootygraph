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

struct PhotoFrame: View {
  static let dragThreshold = 200.0
  let media: Attachment
  
  let unflippedRange = (-.pi/2.0)...0
  
  @State var angle: Angle = .radians(0)
  @State var startAngle: Angle = .radians(0)
  
  var body: some View {
    
    let flipGesture = DragGesture(minimumDistance: 40,coordinateSpace: .local)
      .onChanged{ value in
        guard media.description != nil else { return }
        
        var angleTranslation = startAngle.radians + (value.translation.width / Self.dragThreshold) * .pi
        angleTranslation = angleTranslation.clamped(to: (-.pi)...0)
        
        angle = Angle(radians: angleTranslation)
      }
      .onEnded{ value in
        
        guard media.description != nil else { return }
        withAnimation {
          switch angle.radians {
          case ..<(-.pi/2.0):
            angle = Angle(radians: -.pi)
          default:
            angle = Angle(radians: 0)
          }
          startAngle = angle
        }
        
      }
    
    ZStack{
      if let description = media.description {
        Text(description)
          .foregroundColor(.white)
          .padding()
          .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
          .zIndex(unflippedRange.contains(angle.radians) ? -5 : 5)
        
      }
      Rectangle().foregroundColor(.black.opacity(0.5))
        .zIndex(unflippedRange.contains(angle.radians) ? 0 : 3)
      
      LazyImage(url: media.mediaURL) { state in
        if let image = state.image {
          image
            .resizingMode(.aspectFill)
          
        } else {
          Color
            .accentColor.opacity(0.3)
        }
      }
      
      .blur(radius: unflippedRange.contains(angle.radians) ? 0 : 5)
      
      
    }
      .frame(maxWidth:media.width, maxHeight:media.height)
    
    .padding(10)
    .background(Color.white)
    .border(.white, width:10)
    .aspectRatio(media.aspect,contentMode: .fit)
    .shadow(color:.black.opacity(0.3), radius: 10)
    .padding(.bottom,-15)
    .rotation3DEffect(angle, axis: (x: 0, y: 1, z: 0))
    .gesture(flipGesture)
    
  }
}

// Small extension for clamping values
extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}
