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
  @FocusState var focussedItem: WrappedPickerItem?
  @State var showingCamera: Bool = false
  
  var body: some View {
    
    VStack{

      Button("Close") {
        showingPhotoComposer.toggle()
      }
      
      if (viewModel.wrappedPickerItems.count > 0){
        PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: 4,
                     matching: .images) {
          Text("Change selection")
        }
      }
      if (viewModel.wrappedPickerItems.count == 0){
        VStack{
          
          PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: 4,
                       matching: .images) {
            Text("Pick from library")
          }
                       .font(.title)
                       .buttonStyle(.borderedProminent)
          Button("Camera") {
            showingCamera = true
          }
        }
      } else {
        TabView(selection: $viewModel.tabSelection){
          
          ForEach(viewModel.wrappedPickerItems){ item in
            ImageMetaEditor(wrap: item)
              .focused($focussedItem, equals: item)
              .tag(Optional(item))
          }
          if (viewModel.wrappedPickerItems.count > 0){
            Button("Send it") {
              viewModel.postImages()
            }.font(.title)
              .buttonStyle(.borderedProminent)
              .tag(Optional<WrappedPickerItem>.none)

          }
        }.tabViewStyle(.page)


        
        
      }
    }
    .sheet(isPresented: $showingCamera, content: {
      CameraView()
    })
    .onChange(of: viewModel.tabSelection) { newValue in
      focussedItem = newValue
    }

  }
}
struct ImageMetaEditor: View {
  @ObservedObject var wrap: WrappedPickerItem
  var body: some View {
    VStack{
      PickedImageView(wrap: wrap)
        .padding()
        
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
  @ObservedObject var wrap: WrappedPickerItem
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
