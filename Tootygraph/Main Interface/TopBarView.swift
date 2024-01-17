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

struct TopBarView: View {
    @EnvironmentObject var accountsManager: AccountsManager
    @Binding var selectedViewTag: String
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack{
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .padding(15)
                    .frame(width: 52,height:52)
                    .opacity(selectedViewTag == "settings" ? 1.0 : 0.4)
                    .if(selectedViewTag == "settings"){
                        $0.overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 4)

                        }
                    }
                    .tag("settings")
                    .onTapGesture {
                        withAnimation(.spring(duration:0.2)) {
                            selectedViewTag = "settings"
                        }
                    }
                
                ForEach(accountsManager.connections){ connection in
                    
                    LazyImage(url: connection.avatarURL){ state in
                        if let image = state.image {
                            image.resizable()
                        } else {
                            Color.gray
                        }
                    }
                    .frame(width: 52,height:52)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .if(selectedViewTag == connection.serverAccount.niceName){
                        $0.overlay{
                             
                            let highlight = Palette(connection.serverAccount.hue).highlight
                            RoundedRectangle(cornerRadius: 10)
                                    .stroke(highlight, lineWidth: 4)

                        }
                    }
                    
                    .if(connection.serverAccount.niceName != selectedViewTag){
                        $0.opacity(0.7)
                    }
                    .onTapGesture {
                        withAnimation(.spring(duration:0.2)) {
                            selectedViewTag = connection.serverAccount.niceName
                        }
                    }
                    
                    .tag(connection.serverAccount.niceName)
                }
            }
        }
        .scrollClipDisabled()
        .padding(.horizontal)
        .padding(.bottom,10)
        .background(
            Material.bar
        )
        
    }
}


//
//struct TopBar<Content: View>: View {
//
//    @ViewBuilder var content: () -> Content
//
//    var body: some View {
//
//        HStack{
//
//            content()
//                .foregroundColor(.background.opacity(0.7))
//                .frame(width: 56,height:56)
//                .clipShape(RoundedRectangle(cornerRadius: 5))
//                .background {
//                    RoundedRectangle(cornerRadius: 6).padding(-2).foregroundColor(.accentColor)
//                }
//        }
//    }
//
//}
//
//
//struct TopBarItem: View {
//    var image: Image
//
//    var body: some View {
//        image
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .frame(width: 32,height:32)
//    }
//}
//
//struct TopBar_Previews: PreviewProvider{
//
//
//    static var previews: some View{
//
//        TopBar{
//            Image(systemName: "gearshape.fill").asf()
//            Image("hat").asf()
//            Image("carp").asf()
//            Image("heaton").asf()
//            Text("What")
//        }
//
//
//    }
//
//}
//