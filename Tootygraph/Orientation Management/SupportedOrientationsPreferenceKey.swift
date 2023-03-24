//
//  SupportedOrientationsPreferenceKey.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 21/03/2023.
//

import SwiftUI
import UIKit

struct SupportedOrientationsPreferenceKey: PreferenceKey {
    static var defaultValue: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .pad ? .all : .allButUpsideDown
    }

    static func reduce(value: inout UIInterfaceOrientationMask, nextValue: () -> UIInterfaceOrientationMask) {
        value.formIntersection(nextValue())
    }
}
