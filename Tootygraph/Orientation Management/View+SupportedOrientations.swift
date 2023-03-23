//
//  View+SupportedOrientations.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 21/03/2023.
//

import SwiftUI
import UIKit

extension View {
    func supportedOrientations(_ supportedOrientations: UIInterfaceOrientationMask) -> some View {
        preference(key: SupportedOrientationsPreferenceKey.self, value: supportedOrientations)
    }
}
