//
//  OrientedFullScreenCover.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 21/03/2023.
//

import Foundation
import SwiftUI

struct OrientedFullScreenCover<CoverContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let coverContent: () -> CoverContent
  @State private var supportedOrientations: UIInterfaceOrientationMask = SupportedOrientationsPreferenceKey.defaultValue

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                coverContent()
            }
            .onChange(of: isPresented, perform: {
              supportedOrientations = $0 ?  .portrait : SupportedOrientationsPreferenceKey.defaultValue
            })
            .supportedOrientations(supportedOrientations)
    }
}

extension View {
    func orientedFullScreenCover(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> some View) -> some View {
        modifier(OrientedFullScreenCover(isPresented: isPresented, coverContent: content))
    }
}
