//
//  PhotoComposer.swift
//  Tootygraph
//
//  Created by Sam Easterby-Smith on 26/02/2023.
//

import SwiftUI
import PhotosUI

struct PhotoComposer: View {
  @Binding var showingPhotoComposer: Bool
  @ObservedObject var viewModel: PhotoComposerViewModel
  @FocusState var focussedItem: PickerImageStateWrap?
  
  var body: some View {
    
    VStack{
      Button("Close") {
        showingPhotoComposer.toggle()
      }
      if (viewModel.imageStates.count > 0){
        PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: 4,
                     matching: .images) {
          Text("Change selection")
        }
      }
      TabView {
        if (viewModel.imageStates.count == 0){
          VStack{
            
            PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: 4,
                         matching: .images) {
              Text("PICK PICKTURES")
            }
                         .font(.title)
                         .buttonStyle(.borderedProminent)
                         
          }
        }
        ForEach(viewModel.imageStates){ state in
          ImageMetaEditor(wrap: state)
            .focused($focussedItem, equals: state)
            .onAppear{
              focussedItem = state
            }
        }
        if (viewModel.imageStates.count > 0){
          Button("Send it") {
            viewModel.postImages()
          }.font(.title)
          .buttonStyle(.borderedProminent)
            
        }
      }.tabViewStyle(.page)
        
        

      
    }
  }
}
struct ImageMetaEditor: View {
  @ObservedObject var wrap: PickerImageStateWrap
  var body: some View {
    VStack{
        PickedImageView(wrap: wrap)
        
        TextField(text: $wrap.description, prompt: Text("Describe this image"), axis:.vertical ){
          Label("Description", systemImage: "pencil")
        }
        
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(.tertiary))
        .padding(5)
        .padding(.bottom,40)
        
      }
  }
}

struct PickedImageView: View {
  @ObservedObject var wrap: PickerImageStateWrap
  var body: some View {
    switch wrap.state {
    case .success(let image):
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .photoFrame()
    case .failure(let error):
      Text(error.localizedDescription)
    case .loading(let progress):
      ProgressView(value: progress.fractionCompleted)
    case .empty:
      Text("empty")
    }
  }
}
