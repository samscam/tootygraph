//
//  BoxPacker.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 05/02/2023.
//

import SwiftUI

struct ImageWidget: View {
  let image: Image
  let imageSize: CGSize
  var body: some View {
    
    Color.clear.background{
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
        .clipped()
        
    }
    .frame(idealWidth:imageSize.width, idealHeight:imageSize.height)
      .clipped()
      .border(.gray, width: 2)
    
  }
}

struct Boxpacker: Layout{
  
  let spacing: CGFloat
  
  
  
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    
    return CGSize(width: proposal.width ?? .infinity, height: proposal.height ?? .infinity)
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    
    let root: Node = Node(CGRect(x: 0, y: 0, width: proposal.width ?? 0, height: proposal.height ?? 0))
    
    
    for subview in subviews {
      let subviewSize = subview.sizeThatFits(.unspecified) // quick fudge to fit half the width and height
      
      if let node = findNode(root: root, width: subviewSize.width, height: subviewSize.height) {
        
        subview.fit(node: node)
        
        
      }
    }
  }
  
  func findNode(root: Node, width:CGFloat, height:CGFloat) -> Node? {
    if root.used {
      if let right = root.right {
        return findNode(root: right, width: width, height: height)
      } else if let down = root.down {
        return findNode(root: down, width: width, height: height)
      }
    } else if (width <= root.rect.size.width && height <= root.rect.size.height) {
      return root
    }
    
    return nil
    
  }
  
  func splitNode(node: Node,  width:CGFloat, height:CGFloat) -> Node{
    node.used = true
    
    var downRect = node.rect
    downRect.origin.y += height
    downRect.size.height -= height
    node.down = Node(downRect)
    
    var rightRect = node.rect
    rightRect.origin.x += width
    rightRect.size.width -= width
    rightRect.size.height = height
    node.right = Node(rightRect)
    
    return node
  }
  
}

class Node{
  var used: Bool = false
  var rect: CGRect

  var down: Node?
  var right: Node?
  
  init(_ rect: CGRect){
    self.rect = rect
  }
}

extension LayoutSubview {
  func fit(node: Node){
    self.place(at: node.rect.origin, anchor: .topLeading,  proposal: ProposedViewSize(width: node.rect.size.width, height: node.rect.size.height))
  }
}
