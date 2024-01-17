//
//  TootClientEnvironment.swift
//  Tootygraph
//
//  Created by Sam on 17/01/2024.
//

import Foundation
import SwiftUI
import TootSDK

private struct TootClientEnvironmentKey: EnvironmentKey {
    typealias Value = TootClient?
    
    static let defaultValue: TootClient? = nil
}

extension EnvironmentValues {
    var tootClient: TootClient? {
        get { self[TootClientEnvironmentKey.self] }
        set { self[TootClientEnvironmentKey.self] = newValue }
    }
}
