//
//  FancyPicker.swift
//  Tootygraph
//
//  Created by Sam on 14/01/2024.
//

import Foundation
import SwiftUI


private struct RectPreferenceKey: PreferenceKey {
    static let defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        
        if (nextValue() != .zero){
            value = nextValue()
        }
    }
}

struct FancyPicker<I,Content: View>: View where I: Identifiable & Hashable {
    
    let items: [I]
    @Binding var selection: I?
    @ViewBuilder let itemBuilder: (I) -> Content
    
    @State var selectedRect: CGRect = .zero
    
    var body: some View {
        ZStack{
            FancyIndicator(rect:$selectedRect)
                
            HStack{
                
                ForEach(items){ item in
                    
                    itemBuilder(item)
                        
                        .background{
                            GeometryReader{ proxy in
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.gray, lineWidth: 2)
                                    .if(item == selection){
                                        $0.preference(key: RectPreferenceKey.self,
                                            value: proxy.frame(in: .named("pickerSpace"))
                                        )
                                    }
                                
                            }
                            
                        }
                        .onTapGesture {
                            withAnimation{
                                selection = item
                            }
                        }
                    
                }
            }
        }.onPreferenceChange( RectPreferenceKey.self) { value in
            print("Oh what \(value)")
            withAnimation{
                selectedRect = value
            }
        }.coordinateSpace(.named("pickerSpace"))

    }
}

struct FancyIndicator: View {

    @Binding var rect: CGRect
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.accent)
            .stroke(.black,lineWidth: 4)
            .frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)

    }
}


#if DEBUG

struct SampleItem: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let image: Image
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

struct SampleItemView: View {
    let sampleItem: SampleItem
    
    var body: some View {
        VStack{
            Text(sampleItem.name)
        }
    }
}

struct ContainingFancyView: View {
    let items: [SampleItem] = [
        SampleItem(id: "one", name: "Wibblywobble", image: Image(systemName: "person")),
        SampleItem(id: "two", name: "Bar", image: Image(systemName: "person")),
        SampleItem(id: "three", name: "Bankyi", image: Image(systemName: "person")),
        SampleItem(id: "four", name: "What", image: Image(systemName: "person"))
    ]
    @State var selectedItem: SampleItem?
    
    var body: some View {
        FancyPicker(items: items, selection: $selectedItem){ item in
            SampleItemView(sampleItem: item)
                .padding()
        }
    }
}


#Preview(traits:.sizeThatFitsLayout) {
    
    return ContainingFancyView()
}

#endif
