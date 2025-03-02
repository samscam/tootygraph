//
//  SwipeableTabView.swift
//  Tootygraph
//
//  Created by Sam on 28/01/2024.
//

import Foundation
import SwiftUI


struct CustomTabView<Content: View, Selection: Hashable>: View {
    @Binding var selection: Selection?
    
    @ViewBuilder var content: () -> Content

    
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing:0){
                content()
                    .frame(maxHeight:.infinity)
                    .containerRelativeFrame(.horizontal)
            }.scrollTargetLayout()
        }
        .scrollPosition(id: $selection)
        .scrollIndicators(.never)
        .scrollClipDisabled(true)
        .scrollTargetBehavior(.viewAligned)
    }
}


#Preview {
    @Previewable @State var selection: String?
    return VStack{
        CustomTabView(selection: $selection){
            
            VStack{
                ScrollView{
                    Text("One").font(.title)
                    Text("""
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc consequat maximus pellentesque. Praesent non elementum tortor, eget laoreet tellus. Sed lacinia, turpis sed porta mollis, turpis sapien scelerisque est, eget rhoncus nibh ex et sem. Suspendisse vitae egestas elit. Fusce viverra hendrerit aliquet. Vivamus fermentum, sem ac elementum ultricies, justo tortor sagittis quam, posuere malesuada massa diam eu nisl. Donec eget erat eget justo aliquam ultrices vestibulum sed nisi. Donec egestas ornare leo ac dictum. Phasellus ligula lectus, imperdiet sed mauris vel, accumsan posuere libero.

Vestibulum lobortis accumsan pretium. Sed in auctor erat. Pellentesque ornare est hendrerit purus interdum, a mollis ex vehicula. Etiam pretium sem at lectus sagittis sodales. Aliquam aliquet ut ex a volutpat. Nunc tempor lectus tincidunt sapien pretium tempor. Aliquam eu pellentesque velit. Maecenas ante lacus, mattis a nisi ut, rutrum cursus libero. Cras at tellus dignissim justo hendrerit molestie eu eu velit. Donec id magna ac est malesuada condimentum quis ut lacus. Maecenas in lacinia risus. Morbi nisi elit, dignissim sed posuere non, fermentum eu augue.

Vestibulum rhoncus consectetur turpis id feugiat. Sed ut elementum leo. Nullam dictum fringilla posuere. Vivamus viverra nibh a leo imperdiet aliquet. Sed commodo lacus elit, quis condimentum nibh porta quis. Nunc iaculis sem ac vestibulum interdum. Nam dictum gravida pellentesque. Donec nec bibendum velit, eget suscipit sem. Donec porta turpis non diam tempor, nec aliquet velit gravida. Suspendisse sit amet ornare dui. Donec ut dolor porttitor, tristique nunc et, gravida quam. Donec pretium vulputate felis. Cras non odio eu velit dapibus eleifend. Etiam congue ipsum vel velit lacinia pellentesque. Ut non facilisis tellus, eu pulvinar ante. Sed venenatis felis justo, sed commodo ex sagittis et.

Pellentesque vel augue sollicitudin, molestie orci id, porta dui. Proin et lorem at lectus bibendum sollicitudin. Aliquam feugiat, enim at malesuada vestibulum, augue velit mollis est, molestie facilisis massa sem a est. Quisque tincidunt euismod imperdiet. Ut eget augue pretium, ultrices sem finibus, auctor sapien. In tortor orci, mollis sit amet pulvinar eget, condimentum at lorem. Phasellus vitae libero ipsum. In id enim ullamcorper, suscipit nunc eu, bibendum magna. Cras molestie tristique risus at suscipit. Fusce imperdiet aliquam quam. Suspendisse aliquam nisi lectus, et dapibus justo egestas vel. In ullamcorper sodales lectus vitae elementum. Etiam ultricies faucibus fermentum. Vivamus nulla lorem, sodales in purus nec, pharetra faucibus mauris. Donec ut gravida elit.
""")
                }
                .scrollClipDisabled(true)

            }
            .padding()
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(.blue)
            
            Text("Two").id("2").background(.red)
            Text("Three").id("3").background(.yellow)
        }.onChange(of: selection) {
            print(selection ?? "none")
        }
        .safeAreaInset(edge: .bottom) {
            
            Button(action: {
                withAnimation{
                    selection = "3"
                }
            }, label: {
                Text("Button").frame(maxWidth:.infinity)
                
            })
            .padding()
            .background(Material.bar)
        }

    }
}
