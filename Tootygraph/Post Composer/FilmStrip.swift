//
//  FilmStrip.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 11/07/2023.
//

// With inspiration from
// https://gist.github.com/kylehughes/209558455c5854a3bc27e9a9b980fdd6

import Foundation
import SwiftUI


struct FilmStrip<Content: View>: View {

  @ViewBuilder var content: () -> Content

  var body: some View {
    
    HStack{
      content()
    }
    .background{
      FilmEdge().fill(Color.black, style: FillStyle(eoFill: true))
    }
  }
}

struct FilmEdge {
  let holeEdgeInset: CGFloat = 5
  let holeSize = CGSize(width: 8, height: 12 )
  let space: CGFloat = 15
  let padding: CGFloat = 7
  let cornerSize = CGSize(width: 3, height: 3)
}

extension FilmEdge: Shape {

  func path(in rect: CGRect) -> Path {
    let rect = rect//.insetBy(dx: 0, dy: -holeEdgeInset*2 - holeSize.height)
    var shape = Rectangle().path(in: rect)
    var x: CGFloat = rect.origin.x
    var y: CGFloat = rect.origin.y + holeEdgeInset
    
    while x < rect.width {
      let holeRect = CGRect(origin: CGPoint(x: x, y: y) , size: holeSize)
      shape.addRoundedRect(in: holeRect, cornerSize: cornerSize)
      x += holeSize.width + space
    }
    
    x=0
    y = rect.origin.y + rect.height - holeSize.height - holeEdgeInset
    while x < rect.width {
      let holeRect = CGRect(origin: CGPoint(x: x, y: y) , size: holeSize)
      shape.addRoundedRect(in: holeRect, cornerSize: cornerSize)
      x += holeSize.width + space
    }
    return shape
  }
}


struct FilmStrip_Previews: PreviewProvider{

  static var previews: some View{

      FilmStrip{
        Image("hat").resizable().aspectRatio(contentMode: .fit)
        Image("macs").resizable().aspectRatio(contentMode: .fit)
        Image("hat").resizable().aspectRatio(contentMode: .fit)
        Image("macs").resizable().aspectRatio(contentMode: .fit)
        Image("hat").resizable().aspectRatio(contentMode: .fit)
        Image("macs").resizable().aspectRatio(contentMode: .fit)
      }
      .frame(width: 200,height:135)
      
  }
  
}
