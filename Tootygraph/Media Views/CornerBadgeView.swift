//
//  CornerBadge.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 21/02/2023.
//

import SwiftUI

struct CornerBadge<Content:View>: View {
  
  let content: Content
  let alignment: Alignment
  
  
  @State var width: CGFloat = 0
  @State var height: CGFloat = 0
  
  var rot: Angle {
    switch alignment {
    case .topLeading:
      return .radians(-.pi/4)
    case .topTrailing:
      return .radians(.pi/4)
    case .bottomLeading:
      return .radians(.pi/4)
    case .bottomTrailing:
      return .radians(-.pi/4)
    default:
      return .radians(0)
    }
  }
  
  var offset: CGPoint {
    switch alignment {
    case .topLeading:
        return CGPoint(x: -1, y: -1)
    case .topTrailing:
      return CGPoint(x: 1, y: -1)
    case .bottomLeading:
      return CGPoint(x: -1, y: 1)
    case .bottomTrailing:
      return CGPoint(x: 1, y: 1)
    default:
      return CGPoint.zero
    }
  }
  
  var arrowDirection: Triangle.Direction {
    switch alignment {
    case .topLeading,.topTrailing:
      return .up
    default:
      return .down
    }
  }

  
  init(alignment: Alignment = .bottomTrailing, @ViewBuilder content:  ()-> Content){
    self.content = content()
    self.alignment = alignment
  }
  
  var body: some View {
    
    let hyp = width + (height * 2)
    let side = sqrt(pow(hyp,2)/2)
    let a = sqrt(pow(width,2)/2)
    let b = sqrt(pow(height,2)/2)
    let off = (side - b - a)/2
    
    content
      .fixedSize(horizontal: true, vertical: true)
      .overlay{
        GeometryReader { textGeometry in
          Color.clear.onAppear{
            width = textGeometry.size.width
            height = textGeometry.size.height
          }
          
        }
      }
      .background{
        Triangle(direction: arrowDirection)
          .fill(.foreground)
      }
    
      .rotationEffect(rot)
      .frame(width:side,height:side)
    
      .offset(x: offset.x * off, y: offset.y * off)
  }
  
  struct Triangle: Shape{
    enum Direction {
      case up
      case down
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
      let width = rect.width
      let height = rect.height
      return Path { path in
        switch direction{
        case .down:
          path.move(to: CGPoint(x: -height, y: 0))
          path.addLine(to: CGPoint(x: width + height , y: 0))
          path.addLine(to: CGPoint(x: width / 2 , y: height + (width / 2)))
        case .up:
          path.move(to: CGPoint(x: -height, y: height))
          path.addLine(to: CGPoint(x: width + height , y: height))
          path.addLine(to: CGPoint(x: width / 2 , y: -(width / 2)))
        }

      }
    }
  }
}
#Preview {
    CornerBadge(alignment: .bottomTrailing) {
        Text("Hello there")
    }
}
