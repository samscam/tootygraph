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
    
    @MainActor
    var highlight: some ShapeStyle {
        return PaletteHighlightColor(hue)
    }
    
    @MainActor
    var background: some ShapeStyle {
        return PaletteBackgroundColor(hue)
    }
    
    @MainActor
    var postBackground: some ShapeStyle {
        return PalettePostBackgroundColor(hue)
    }
    
    init(_ hue: Double) {
        self.hue = hue
    }
    
}

struct PaletteHighlightColor: View, ShapeStyle {
    let hue: Double
    
    init(_ hue: Double) {
        self.hue = hue
    }
    
    nonisolated func resolve(in environment: EnvironmentValues)-> some ShapeStyle  {
        if environment.colorScheme == .light {
            return lightHighlight
        } else {
            return darkHighlight
        }
    }
    

    nonisolated private var darkHighlight: Color {
        return Color(hue: hue, saturation: 0.9, brightness: 0.85)
    }

    nonisolated private var lightHighlight: Color {
        return Color(hue: hue, saturation: 0.9, brightness: 0.85)
    }
    
}

struct PaletteBackgroundColor: View, ShapeStyle {
    let hue: Double
    
    init(_ hue: Double) {
        self.hue = hue
    }
    
    nonisolated func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        if environment.colorScheme == .light {
            return lightBackground
        } else {
            return darkBackground
        }
    }
    
    nonisolated private var lightBackground: Color {
        return Color(hue: hue, saturation: 0.1, brightness: 1.0)
    }
    
    
    nonisolated private var darkBackground: Color {
        return Color(hue: hue, saturation: 1.0, brightness: 0.35)
    }
}


struct PalettePostBackgroundColor: View, ShapeStyle {
    let hue: Double
    
    init(_ hue: Double) {
        self.hue = hue
    }
    
    nonisolated func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        if environment.colorScheme == .light {
            return lightBackground
        } else {
            return darkBackground
        }
    }
    
    nonisolated private var lightBackground: Color {
        return Color(hue: hue, saturation: 0.01, brightness: 1.0)
    }
    
    
    nonisolated private var darkBackground: Color {
        return Color(hue: hue, saturation: 0.2, brightness: 0.2)
    }
}

extension Palette {
    static func random() -> Palette {
        let hue = Double.random(in: 0...1)
        return Palette(hue)
    }
    
    static func standard() -> Palette {
        let hue = 0.5
        return Palette(hue)
    }
}

private struct PaletteEnvironmentKey: EnvironmentKey {
    static let defaultValue: Palette = Palette.random()
}

extension EnvironmentValues {
    var palette: Palette {
        get { self[PaletteEnvironmentKey.self] }
        set { self[PaletteEnvironmentKey.self] = newValue }
    }
}

extension View {
    func palette(_ palette: Palette) -> some View {
        environment(\.palette, palette)
            .tint(palette.highlight)
    }
}

struct ColourSample: View{
    let palette: Palette
    
    var body: some View {
        
            HStack{
                Text("Primary").bold()
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
                    .foregroundStyle(.primary)
                
                Text("Tint").bold()
                    .foregroundStyle(palette.highlight)
                
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(palette.postBackground)
                    }
                    .padding()
                Button("Prominent", role: .none) {}.buttonStyle(.borderedProminent)
                Button("Borderless", role: .none) {}.buttonStyle(.borderless)
                Button("Bordered", role: .none) {}.buttonStyle(.bordered)
            }
            .tint(palette.highlight)
            .background(palette.background)
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


