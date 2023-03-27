//
//  BottomBar.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 06/02/2023.
//

import Foundation

import SwiftUI
import TootSDK

struct BottomBar: View {
  @State var showingPhotoComposer: Bool = false
  @StateObject var photoComposerViewModel: PhotoComposerViewModel
  
  init(tootClient: TootClient?){
    _photoComposerViewModel = StateObject(wrappedValue: PhotoComposerViewModel(tootClient: tootClient))
  }
  
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
        .orientedFullScreenCover(isPresented: $showingPhotoComposer){
          PhotoComposer(showingPhotoComposer: $showingPhotoComposer, viewModel: photoComposerViewModel)
        }
      Spacer()
    }
//    .background(LinearGradient(colors: [.clear,Color.background.opacity(0.5)], startPoint: .top, endPoint: .bottom))

    
  }
}
struct BottomBar_Previews: PreviewProvider{
  static var previews: some View{
    BottomBar(tootClient: nil)
  }
}
