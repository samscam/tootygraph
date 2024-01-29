//
//  FlippingBars.swift
//  Tootygraph
//
//  Created by Sam on 29/01/2024.
//

import Foundation
import SwiftUI

enum FlippingOrientation {
    case bottomLeading
    case topTrailing
}

struct FlippingBar<Innards:View>: ViewModifier {
        

    let flipped: Bool
    let orientation: FlippingOrientation

    @ViewBuilder var innards: () -> Innards
    
    func body(content: Content) -> some View {
        switch (flipped, orientation){
        case (true,.bottomLeading):
            content
                .safeAreaInset(edge: .leading) {
                    innards()
                }
        case (true,.topTrailing):
            content
                .safeAreaInset(edge: .trailing) {
                    innards()
                }
        case (false,.bottomLeading):
            content
                .safeAreaInset(edge: .bottom) {
                    innards()
                }
        case (false,.topTrailing):
            content
                .safeAreaInset(edge: .top) {
                    innards()
                }
        }
    }
    
}

extension View {
    func flippingBar<Innards:View>(flipped: Bool,
                                   orientation: FlippingOrientation,
                                   innards: @escaping () -> Innards) -> some View {
        modifier(FlippingBar(flipped: flipped, orientation: orientation, innards:innards))
    }
}
