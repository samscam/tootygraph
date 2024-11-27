//
//  ConnectionLozenge.swift
//  Tootygraph
//
//  Created by Sam on 26/11/2024.
//

import SwiftUI
import NukeUI

struct ConnectionLozenge: View {
    let connection: Connection
    let horizontal: Bool
    @Binding var selectedFeed: UUID?
    
    var body: some View {
        FlippingStackView(horizontal: horizontal){
            LazyImage(url: connection.avatarURL){ state in
                if let image = state.image {
                    image.resizable()
                } else {
                    Color.gray
                }
            }
            .frame(width: 42,height:42)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            ForEach(connection.feeds, id:\.id){ feed in
                Button {
                    withAnimation {
                        selectedFeed = feed.id
                    }
                   
                } label: {
                    Image(systemName: feed.iconName)
                        .resizable()
                        
                        .padding(5)
                        .frame(width: 42,height:42)
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(connection.palette.background)
                                .stroke(highlightStyle(for: feed.id),lineWidth:4)
                                
                        }
                }
                .buttonStyle(.plain)
                .tint(connection.palette.highlight)
            }
        }
        .padding(5)
        .background{
            RoundedRectangle(cornerRadius: 10)
//                .stroke(lozengeStyle)
//                .blur(radius: 2)
        }
    }
    
//    var lozengeStyle: some ShapeStyle {
//
//        let background: AnyShapeStyle
//        if let selectedFeed,
//           selectedFeed.account == connection.account.niceName {
//            background = AnyShapeStyle(connection.palette.highlight)
//        } else {
//            background = AnyShapeStyle(connection.palette.postBackground)
//        }
//        return background
//    }
//
    @MainActor
    func highlightStyle(for feed: UUID) -> some ShapeStyle{
        if let selectedFeed,
           selectedFeed == feed {
            return AnyShapeStyle(connection.palette.highlight)
        } else {
            return AnyShapeStyle(.clear)
        }
    }
}

#Preview {
    @Previewable @State var selectedFeed: UUID? = nil
    @Previewable @State var connection: Connection = {
        let con = Connection(account: FediAccount.Samples.sam)
        Task{
            try await con.connect()
        }
        return con
    }()
    
    return ConnectionLozenge(connection: connection, horizontal: true, selectedFeed: $selectedFeed)
}
