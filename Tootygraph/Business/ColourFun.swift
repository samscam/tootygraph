//
//  ColourFun.swift
//  Tootygraph
//
//  Created by Sam on 08/01/2024.
//

import Foundation
import CoreGraphics
import SwiftUI



struct Palette {
    
    var hue: Double
    
    var highlight: some ShapeStyle {
        return PaletteHighlightColor(hue)
    }
    
    var background: some ShapeStyle {
        return PaletteBackgroundColor(hue)
    }
    
    init(_ hue: Double) {
        self.hue = hue
    }
    
}

struct PaletteHighlightColor: View, ShapeStyle {
    var hue: Double
    
    init(_ hue: Double) {
        self.hue = hue
    }
    
    func resolve(in environment: EnvironmentValues)-> some ShapeStyle  {
        if environment.colorScheme == .light {
            return lightHighlight
        } else {
            return darkHighlight
        }
    }
    

    private var darkHighlight: Color {
        return Color(hue: hue + 0.05, saturation: 0.6, brightness: 1.0)
    }

    private var lightHighlight: Color {
        return Color(hue: hue + 0.05, saturation: 1.0, brightness: 0.55)
    }
    
}

struct PaletteBackgroundColor: View, ShapeStyle {
    var hue: Double
    
    init(_ hue: Double) {
        self.hue = hue
    }
    
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        if environment.colorScheme == .light {
            return lightBackground
        } else {
            return darkBackground
        }
    }
    
    private var lightBackground: Color {
        return Color(hue: hue, saturation: 0.2, brightness: 1.0)
    }
    
    
    private var darkBackground: Color {
        return Color(hue: hue, saturation: 1.0, brightness: 0.3)
    }
}

extension Palette {
    static func random() -> Palette {
        let hue = Double.random(in: 0...1)
        return Palette(hue)
    }
}

struct ColourSample: View{
    let palette: Palette
    
    var body: some View {
        
        HStack {
            HStack{
                Text("Primary").bold()
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
                    .foregroundStyle(.primary)
                
                Text("Tint").bold()
                    .foregroundStyle(palette.highlight)
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
            }
        }
    }
}


#Preview {
    
    return
        List(0..<10, id: \.self) { i in
            ColourSample(palette: Palette(Double(i)/10.0))
                .frame(height:70)
        }.listStyle(.plain)

    
}




public extension Color {

    #if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
    #else
//    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    #endif
}
