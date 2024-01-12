//
//  ColourFun.swift
//  Tootygraph
//
//  Created by Sam on 08/01/2024.
//

import Foundation
import CoreGraphics
import SwiftUI

struct Hue: Codable, Equatable, Hashable {
    
    var hue: Double
    
    var background: Color {
        return Color(hue: hue, saturation: 0.5, brightness: 0.5)
    }
    var foreground: Color {
        return Color(hue: hue, saturation: 1.0, brightness: 1.0)
    }
    
    var compliment: Color {
        return Color(hue: hue+0.3, saturation: 1.0, brightness: 1.0)
    }
    
    init(_ hue: Double) {
        self.hue = hue
    }
    
}

extension Hue {
    static func random() -> Hue {
        let hue = Double.random(in: 0...1)
        return Hue(hue)
    }
}
