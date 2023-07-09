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
        .foregroundColor(.white)
        .frame(width: 40,height:40)
        .padding(10)
        .background(
          Circle().foregroundColor(.black)
        )
        .shadow(color:.white,radius: 20)
        .onTapGesture {
          showingPhotoComposer.toggle()
        }
        .orientedFullScreenCover(isPresented: $showingPhotoComposer){
          PhotoComposer(viewModel: photoComposerViewModel)
        }
      Spacer()
    }
    .background(LinearGradient(colors: [.clear,Color.background.opacity(0.4)], startPoint: .top, endPoint: .bottom))

    
  }
}
struct BottomBar_Previews: PreviewProvider{
  static var previews: some View{
    VStack{
      Text("Hello")
      Spacer()
    }
      .safeAreaInset(edge: .bottom, spacing: 0) {
        BottomBar(tootClient: nil)
      }
      .background{
          Image("wood-texture").resizable()
            .ignoresSafeArea()
      }
  }
  
}
