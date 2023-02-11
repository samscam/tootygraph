//
//  NavStack.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 10/02/2023.
//

import SwiftUI

struct NavStack<Content: View, Detail: View>: View{
  
  let content: Content
  let detail: Detail?
  
  init(@ViewBuilder _ content: () -> Content,
       detail: (() -> Detail)?){
    self.content = content()
    self.detail = detail?()
  }
  
  var body: some View{
    ZStack{
      if let detail {
        detail
      } else {
        content
      }
      Image("wood-texture").resizable().edgesIgnoringSafeArea(.all)
      
      
    }
  }
}
