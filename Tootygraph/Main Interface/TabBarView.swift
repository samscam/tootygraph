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

struct TabBarView: View {
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
                    .if(selectedViewTag == connection.account.id){
                        $0.overlay{
                             
                            let highlight = connection.palette.highlight
                            RoundedRectangle(cornerRadius: 10)
                                    .stroke(highlight, lineWidth: 4)

                        }
                    }
                    
                    .if(connection.account.id != selectedViewTag){
                        $0.opacity(0.7)
                    }
                    .onTapGesture {
                        withAnimation(.spring(duration:0.2)) {
                            selectedViewTag = connection.account.id
                        }
                    }
                    
                    .tag(connection.account.id)
                }
            }
        }
        .scrollClipDisabled()
        .padding(10)
        .background(
            Material.bar
        )
        
    }
}

#Preview {
    let accountsManager = AccountsManager()
    @State var selectedViewTag: String = "preferences"
    
    return TabBarView(selectedViewTag: $selectedViewTag).environmentObject(accountsManager)
}
