//
//  TopBar.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 03/09/2023.
//

import Foundation
import SwiftUI
import TootSDK
import NukeUI

struct TopBar<Content: View>: View {
    
    @ViewBuilder var content: () -> Content

    var body: some View {
        
        HStack{

            content()
                .foregroundColor(.background.opacity(0.7))
                .frame(width: 56,height:56)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .background {
                    RoundedRectangle(cornerRadius: 6).padding(-2).foregroundColor(.accentColor)
                }
        }
    }

}


struct TopBarItem: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 32,height:32)
    }
}

struct TopBar_Previews: PreviewProvider{
    
    
    static var previews: some View{

        TopBar{
            Image(systemName: "gearshape.fill").asf()
            Image("hat").asf()
            Image("carp").asf()
            Image("heaton").asf()
            Text("What")
        }
            

    }
    
}

extension Image {
    func asf() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fill)
    }
}
