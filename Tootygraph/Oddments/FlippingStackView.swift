//
//  FlippingStackView.swift
//  Tootygraph
//
//  Created by Sam on 29/01/2024.
//

import Foundation
import SwiftUI

struct FlippingStackView<Content:View>: View {
    
    let horizontal: Bool
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if horizontal {
            HStack{
                content()
            }
        } else {
            VStack{
                content()
            }
        }
    }
}
