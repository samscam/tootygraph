//
//  SwipeableTabView.swift
//  Tootygraph
//
//  Created by Sam on 28/01/2024.
//

import Foundation
import SwiftUI


struct SwipeableTabView<Content: View, Selection: Hashable>: View {
    @Binding var selection: Selection?
    
    @ViewBuilder var content: () -> Content

    
    var body: some View {
        GeometryReader{ geometry in
            
            ScrollView(.horizontal){
                LazyHStack(spacing:0){
                    content()
                        .frame(width:geometry.size.width , height: geometry.size.height)
                }.scrollTargetLayout()
            }
            .scrollPosition(id: $selection)
            .scrollIndicators(.never)
            .scrollClipDisabled(true)
            .scrollTargetBehavior(.viewAligned)

        }
    }
}


#Preview {
    @Previewable @State var selection: String?
    return VStack{
        SwipeableTabView(selection: $selection){
            Text("One").id("1").background(.blue)
            Text("Two").id("2").background(.red)
            Text("Three").id("3").background(.yellow)
        }.onChange(of: selection) {
            print(selection ?? "none")
        }
        Button(action: {
            selection = "3"
        }, label: {
            Text("Button")
        })
    }
}
