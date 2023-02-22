//
//  Flipper.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 19/02/2023.
//

import SwiftUI

struct Flipper<Front:View, Rear:View>: View {
  
  @Binding var flipped: Bool
  
  let frontView: Front
  let rearView: Rear
  

  var body: some View{
    
    ZStack{
      frontView
        .modifier(FlipOpacity(opacity: flipped ? 0 : 1))
        .rotation3DEffect(.radians(flipped ? .pi : .pi * 2 ), axis: (x: 0, y: 1, z: 0))
      rearView
        .modifier(FlipOpacity(opacity: flipped ? 1 : 0))
        .rotation3DEffect(.radians(flipped ? 0 : .pi ), axis: (x: 0, y: 1, z: 0))
    }
  }
}

private struct FlipOpacity: ViewModifier, Animatable{
  var opacity: CGFloat = 0
  
  var animatableData: CGFloat {
    get { opacity }
    set { opacity = newValue }
  }
  
  func body(content: Content) -> some View {
     content
          .opacity(Double(opacity.rounded()))
  }
  
}
