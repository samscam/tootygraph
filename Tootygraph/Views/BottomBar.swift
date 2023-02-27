//
//  BottomBar.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 06/02/2023.
//

import Foundation

import SwiftUI

struct BottomBar: View {
  @State var showingPhotoComposer: Bool = false
  @StateObject var photoComposerViewModel = PhotoComposerViewModel()
  
  var body: some View {
    HStack{
      Spacer()
      Image(systemName: "camera")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.black)
        .frame(width: 40,height:40)
        .padding(10)
        .background(
          Circle().foregroundColor(.accentColor)
        )
        .shadow(radius: 10)
        .onTapGesture {
          showingPhotoComposer.toggle()
        }
        .fullScreenCover(isPresented: $showingPhotoComposer) {
          PhotoComposer(showingPhotoComposer: $showingPhotoComposer, viewModel: photoComposerViewModel)
        }
      Spacer()
    }
//    .background(LinearGradient(colors: [.clear,Color.background.opacity(0.5)], startPoint: .top, endPoint: .bottom))

    
  }
}
struct BottomBar_Previews: PreviewProvider{
  static var previews: some View{
    BottomBar()
  }
}
